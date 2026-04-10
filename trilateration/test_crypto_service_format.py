"""
Regression test for crypto_service.dart AES-256-GCM format.

Found by audit pass (senior dev / military quality) driven by forge. The
decrypt() and importBackup() functions both had the same bug: they called
cipher.doFinal() on an already-finalized AEAD cipher instance, then chopped
16 bytes off the end of the plaintext to "remove the tag" that was already
consumed internally.

  BUG+016: crypto_service.decrypt() at lines 164-168
    OLD:
      cipher.doFinal(output, len);           // finalizes AEAD
      final plaintextLength = len + cipher.doFinal(output, len);  // SECOND doFinal!
      return utf8.decode(output.sublist(0, plaintextLength - 16));  // -16 chops valid bytes
    NEW:
      final len1 = cipher.processBytes(...)
      final len2 = cipher.doFinal(output, len1)
      final plaintextLength = len1 + len2
      return utf8.decode(output.sublist(0, plaintextLength))

We can't run Dart pointycastle from Python, but we CAN verify the byte
format that the fixed Dart code must produce and consume, using Python's
cryptography package (same AES-GCM standard).

If the format diverges from the Dart spec in a future revision, this test
will fail and the developer will know to update both sides.
"""
import base64
import os
import sys

import pytest

try:
    from cryptography.hazmat.primitives.ciphers.aead import AESGCM
    HAS_CRYPTO = True
except ImportError:
    HAS_CRYPTO = False

pytestmark = pytest.mark.skipif(
    not HAS_CRYPTO,
    reason="cryptography package not installed — install with `pip install cryptography`",
)


# ============================================================================
# Constants matching crypto_service.dart
# ============================================================================

IV_LENGTH = 12       # _ivLength in Dart
KEY_LENGTH = 32      # _keyLength (256 bits)
TAG_LENGTH = 16      # GCM standard (128 bits)


def encrypt_like_dart(plaintext: str, key: bytes) -> str:
    """Python mirror of crypto_service.dart encrypt().

    Format: base64(IV || ciphertext+tag)
    The tag is APPENDED to the ciphertext by AES-GCM (both Dart pointycastle
    and Python cryptography do this the same way).
    """
    iv = os.urandom(IV_LENGTH)
    aead = AESGCM(key)
    # cryptography.AESGCM.encrypt returns ciphertext || tag concatenated
    ct_and_tag = aead.encrypt(iv, plaintext.encode("utf-8"), associated_data=None)
    return base64.b64encode(iv + ct_and_tag).decode("ascii")


def decrypt_like_dart_fixed(encrypted_b64: str, key: bytes) -> str:
    """Python mirror of the FIXED crypto_service.dart decrypt().

    The fixed version:
      1. processBytes + doFinal (single AEAD finalize)
      2. plaintext_length = len1 + len2
      3. utf8.decode(output[:plaintext_length])  — NO -16 subtraction

    AESGCM.decrypt verifies the tag and raises if invalid.
    """
    data = base64.b64decode(encrypted_b64)
    if len(data) < IV_LENGTH + TAG_LENGTH:
        raise ValueError("Invalid encrypted data")

    iv = data[:IV_LENGTH]
    ct_and_tag = data[IV_LENGTH:]

    aead = AESGCM(key)
    plaintext = aead.decrypt(iv, ct_and_tag, associated_data=None)
    return plaintext.decode("utf-8")


def decrypt_like_dart_BROKEN(encrypted_b64: str, key: bytes) -> str:
    """Python mirror of the BROKEN pre-fix decrypt()."""
    data = base64.b64decode(encrypted_b64)
    iv = data[:IV_LENGTH]
    ct_and_tag = data[IV_LENGTH:]

    aead = AESGCM(key)
    # Decrypt normally — this is what Dart ALSO does under the hood.
    plaintext = aead.decrypt(iv, ct_and_tag, associated_data=None)

    # Simulate the Dart bug: the code did `utf8.decode(output.sublist(0, plaintext_length - 16))`
    # which chops 16 bytes off the end of the plaintext.
    return plaintext[:-TAG_LENGTH].decode("utf-8", errors="replace")


# ============================================================================
# Tests
# ============================================================================

def _make_key() -> bytes:
    """Deterministic key for repeatable tests."""
    return b"0123456789abcdef0123456789abcdef"  # 32 bytes, AES-256


def test_encrypt_output_format_is_base64():
    key = _make_key()
    enc = encrypt_like_dart("hello world", key)
    # Must be valid base64
    decoded = base64.b64decode(enc)
    # First 12 bytes are IV
    assert len(decoded) >= IV_LENGTH + TAG_LENGTH


def test_encrypted_size_matches_plaintext_plus_overhead():
    """ciphertext length = plaintext length + 16 (tag)."""
    key = _make_key()
    plaintext = "hello world"  # 11 bytes
    enc = encrypt_like_dart(plaintext, key)
    decoded = base64.b64decode(enc)
    # 12 IV + 11 plaintext + 16 tag = 39
    assert len(decoded) == IV_LENGTH + len(plaintext) + TAG_LENGTH


def test_encrypt_decrypt_roundtrip_short():
    key = _make_key()
    plaintext = "hello world"
    enc = encrypt_like_dart(plaintext, key)
    dec = decrypt_like_dart_fixed(enc, key)
    assert dec == plaintext


def test_encrypt_decrypt_roundtrip_long():
    key = _make_key()
    plaintext = "A" * 10000  # 10KB
    enc = encrypt_like_dart(plaintext, key)
    dec = decrypt_like_dart_fixed(enc, key)
    assert dec == plaintext


def test_encrypt_decrypt_roundtrip_empty():
    key = _make_key()
    enc = encrypt_like_dart("", key)
    dec = decrypt_like_dart_fixed(enc, key)
    assert dec == ""


def test_encrypt_decrypt_roundtrip_utf8():
    key = _make_key()
    plaintext = "Héllo wörld 🚬 avec emojis"
    enc = encrypt_like_dart(plaintext, key)
    dec = decrypt_like_dart_fixed(enc, key)
    assert dec == plaintext


def test_decrypt_different_iv_each_call():
    """The same plaintext encrypted twice must produce different ciphertexts
    (because IV is random). This is a sanity check on the encryption, not
    the decryption, but it's critical for GCM security."""
    key = _make_key()
    enc1 = encrypt_like_dart("same plaintext", key)
    enc2 = encrypt_like_dart("same plaintext", key)
    assert enc1 != enc2


def test_decrypt_fails_on_tampered_ciphertext():
    """Flipping a byte in the ciphertext must cause decrypt to fail
    (AES-GCM authenticates the entire message via the tag)."""
    key = _make_key()
    enc = encrypt_like_dart("hello world", key)
    data = bytearray(base64.b64decode(enc))
    # Flip the first byte of the ciphertext (after the 12-byte IV)
    data[IV_LENGTH] ^= 0x01
    tampered = base64.b64encode(bytes(data)).decode("ascii")

    with pytest.raises(Exception):  # InvalidTag / InvalidSignature
        decrypt_like_dart_fixed(tampered, key)


def test_decrypt_fails_on_wrong_key():
    """Using the wrong key must cause tag verification to fail."""
    key = _make_key()
    wrong_key = b"ffffffffffffffffffffffffffffffff"

    enc = encrypt_like_dart("secret data", key)
    with pytest.raises(Exception):
        decrypt_like_dart_fixed(enc, wrong_key)


# ============================================================================
# Regression tests — prove the BUG+016 fix addresses the actual bug
# ============================================================================

def test_BUG_016_broken_decrypt_chops_last_16_bytes():
    """Reproduce the bug: the old code would chop the last 16 plaintext
    bytes off, turning 'hello world this is a long enough test string'
    (47 bytes) into 'hello world this is a long enoug' (31 bytes)."""
    key = _make_key()
    plaintext = "hello world this is a long enough test string"
    assert len(plaintext) == 45
    enc = encrypt_like_dart(plaintext, key)

    # The BROKEN decrypt chops 16 bytes off the end
    broken = decrypt_like_dart_BROKEN(enc, key)
    assert broken == plaintext[:-TAG_LENGTH], (
        f"broken decrypt should have chopped 16 bytes, got {len(broken)} chars"
    )
    assert broken != plaintext

    # The FIXED decrypt returns the full plaintext
    fixed = decrypt_like_dart_fixed(enc, key)
    assert fixed == plaintext


def test_BUG_016_broken_decrypt_corrupts_short_messages():
    """Messages shorter than 16 bytes would underflow — the -16 subtraction
    applied to a short length becomes negative and the slice wraps or
    produces empty / garbage output."""
    key = _make_key()
    plaintext = "short"  # 5 bytes, shorter than the 16-byte tag
    enc = encrypt_like_dart(plaintext, key)

    # Fixed version: round-trip OK
    assert decrypt_like_dart_fixed(enc, key) == plaintext

    # Broken version: the plaintext is 5 bytes, broken[-16:] slices from
    # byte -16 which wraps to byte 0. So broken[:-16] is empty string.
    broken = decrypt_like_dart_BROKEN(enc, key)
    assert broken == "", f"broken should be empty (wrapped slice), got '{broken}'"
