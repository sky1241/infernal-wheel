import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';

/// Service de chiffrement AES-256-GCM
/// - PIN 4-6 chiffres au 1er lancement (le user choisit)
/// - Derive une cle AES-256 via PBKDF2 (PIN + sel)
/// - Sel stocke dans Android Keystore (flutter_secure_storage)
/// - Toutes les donnees chiffrees avant ecriture sur disque
class CryptoService {
  static final CryptoService _instance = CryptoService._internal();
  factory CryptoService() => _instance;
  CryptoService._internal();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keySalt = 'infernal_salt';
  static const _keyPinHash = 'infernal_pin_hash';
  static const _keySetup = 'infernal_setup_done';

  // PBKDF2 params — 100k iterations (bon compromis securite/perf mobile)
  static const _pbkdf2Iterations = 100000;
  static const _saltLength = 32;
  static const _keyLength = 32; // 256 bits
  static const _ivLength = 12;  // GCM standard

  Uint8List? _derivedKey;
  bool _isUnlocked = false;

  bool get isUnlocked => _isUnlocked;

  static const _keyRawKey = 'infernal_raw_key';

  /// Verifie si le chiffrement a deja ete configure
  Future<bool> isSetup() async {
    final done = await _storage.read(key: _keySetup);
    return done == 'true';
  }

  /// Setup automatique (sans PIN) — genere une cle AES-256 random
  /// La cle est stockee dans Android Keystore (protegee par le verrou du tel)
  Future<void> setupAuto() async {
    final key = _generateRandom(_keyLength);
    _derivedKey = key;
    await _storage.write(key: _keyRawKey, value: base64Encode(key));
    await _storage.write(key: _keySetup, value: 'true');
    _isUnlocked = true;
  }

  /// Deverrouillage automatique (sans PIN) — recupere la cle du Keystore
  Future<void> unlockAuto() async {
    final keyB64 = await _storage.read(key: _keyRawKey);
    if (keyB64 == null) throw StateError('No key found in Keystore');
    _derivedKey = base64Decode(keyB64);
    _isUnlocked = true;
  }

  /// Premier lancement : configure le PIN
  /// Genere un sel random, derive la cle, stocke le tout dans le Keystore
  Future<void> setup(String pin) async {
    _validatePin(pin);

    // Generer sel random
    final salt = _generateRandom(_saltLength);

    // Hash du PIN pour verification ulterieure (SHA-256, pas reversible)
    final pinHash = _hashPin(pin, salt);

    // Deriver la cle AES-256 (dans un isolate pour ne pas bloquer l'UI)
    _derivedKey = await _deriveKeyAsync(pin, salt);

    // Stocker dans le Keystore securise
    await _storage.write(key: _keySalt, value: base64Encode(salt));
    await _storage.write(key: _keyPinHash, value: base64Encode(pinHash));
    await _storage.write(key: _keySetup, value: 'true');

    _isUnlocked = true;
  }

  /// Deverrouille avec le PIN (lancement suivant)
  /// Retourne true si PIN correct, false sinon
  Future<bool> unlock(String pin) async {
    _validatePin(pin);

    final saltB64 = await _storage.read(key: _keySalt);
    final storedHashB64 = await _storage.read(key: _keyPinHash);

    if (saltB64 == null || storedHashB64 == null) return false;

    final salt = base64Decode(saltB64);
    final storedHash = base64Decode(storedHashB64);

    // Verifier le PIN
    final pinHash = _hashPin(pin, salt);
    if (!_constantTimeEquals(pinHash, storedHash)) return false;

    // Deriver la cle (dans un isolate)
    _derivedKey = await _deriveKeyAsync(pin, salt);
    _isUnlocked = true;
    return true;
  }

  /// Verrouille (efface la cle de la memoire)
  void lock() {
    _derivedKey = null;
    _isUnlocked = false;
  }

  /// Chiffre des donnees (String → String base64)
  /// Format: IV (12 bytes) + ciphertext + tag (16 bytes), le tout en base64
  String encrypt(String plaintext) {
    if (_derivedKey == null) throw StateError('CryptoService not unlocked');

    final iv = _generateRandom(_ivLength);
    final plaintextBytes = utf8.encode(plaintext);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(true, AEADParameters(
        KeyParameter(_derivedKey!),
        128, // tag length in bits
        iv,
        Uint8List(0), // no AAD
      ));

    final output = Uint8List(cipher.getOutputSize(plaintextBytes.length));
    final len = cipher.processBytes(plaintextBytes, 0, plaintextBytes.length, output, 0);
    cipher.doFinal(output, len);

    // IV + ciphertext+tag
    final result = Uint8List(_ivLength + output.length);
    result.setRange(0, _ivLength, iv);
    result.setRange(_ivLength, result.length, output);

    return base64Encode(result);
  }

  /// Dechiffre des donnees (String base64 → String)
  ///
  /// Format attendu: IV (12 bytes) || ciphertext+tag (ciphertext.length + 16 bytes)
  ///
  /// BUG+016 fix: la version precedente appelait `cipher.doFinal()` deux fois
  /// sur la meme instance (illegal — AEAD ciphers ne peuvent pas etre reuses
  /// sans re-init) et soustrait "-16 for tag" a la longueur finale, ce qui
  /// tronquait 16 bytes valides du plaintext. Pointycastle GCMBlockCipher
  /// consomme et verifie le tag internement dans doFinal, donc le plaintext
  /// ecrit dans `output` a une longueur = `len + doFinalBytes` et NE
  /// contient PAS le tag.
  String decrypt(String encrypted) {
    if (_derivedKey == null) throw StateError('CryptoService not unlocked');

    final data = base64Decode(encrypted);
    // 12 bytes IV + >= 16 bytes tag = min length 28
    if (data.length < _ivLength + 16) {
      throw const FormatException('Invalid encrypted data');
    }

    final iv = Uint8List.sublistView(data, 0, _ivLength);
    final ciphertextAndTag = Uint8List.sublistView(data, _ivLength);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(false, AEADParameters(
        KeyParameter(_derivedKey!),
        128,
        iv,
        Uint8List(0),
      ));

    final output = Uint8List(cipher.getOutputSize(ciphertextAndTag.length));
    final len1 = cipher.processBytes(ciphertextAndTag, 0, ciphertextAndTag.length, output, 0);
    final len2 = cipher.doFinal(output, len1);
    final plaintextLength = len1 + len2;

    return utf8.decode(output.sublist(0, plaintextLength));
  }

  /// Chiffre pour ecriture fichier
  Future<void> encryptToFile(File file, String content) async {
    final encrypted = encrypt(content);
    await file.writeAsString(encrypted);
  }

  /// Dechiffre depuis fichier
  Future<String?> decryptFromFile(File file) async {
    try {
      if (!await file.exists()) return null;
      final encrypted = await file.readAsString();
      if (encrypted.isEmpty) return null;
      return decrypt(encrypted);
    } catch (_) {
      return null;
    }
  }

  /// Exporte les donnees pour backup (changement de telephone)
  /// Retourne un JSON chiffre avec un mot de passe temporaire
  Future<String> exportBackup(String backupPassword, Map<String, dynamic> data) async {
    final salt = _generateRandom(_saltLength);
    final key = await _deriveKeyAsync(backupPassword, salt);

    final plaintext = jsonEncode(data);
    final iv = _generateRandom(_ivLength);
    final plaintextBytes = utf8.encode(plaintext);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(true, AEADParameters(KeyParameter(key), 128, iv, Uint8List(0)));

    final output = Uint8List(cipher.getOutputSize(plaintextBytes.length));
    final len = cipher.processBytes(plaintextBytes, 0, plaintextBytes.length, output, 0);
    cipher.doFinal(output, len);

    return jsonEncode({
      'v': 1, // version du format
      'salt': base64Encode(salt),
      'iv': base64Encode(iv),
      'data': base64Encode(output),
    });
  }

  /// Importe un backup sur un nouveau telephone
  ///
  /// BUG+016 fix (same as decrypt()): the previous version ignored the
  /// `len` returned by processBytes + doFinal and decoded
  /// `output.sublist(0, output.length - 16)`. That computes `output.length`
  /// which is the getOutputSize() upper bound (ciphertext+tag size), not
  /// the actual plaintext length, and then subtracts 16 to "remove the
  /// tag" — but the tag was already consumed internally by doFinal, so
  /// the subtraction chops 16 valid plaintext bytes.
  Future<Map<String, dynamic>?> importBackup(String backupPassword, String backupJson) async {
    try {
      final backup = jsonDecode(backupJson) as Map<String, dynamic>;
      if (backup['v'] != 1) return null;

      final salt = base64Decode(backup['salt'] as String);
      final iv = base64Decode(backup['iv'] as String);
      final ciphertextAndTag = base64Decode(backup['data'] as String);
      final key = await _deriveKeyAsync(backupPassword, salt);

      final cipher = GCMBlockCipher(AESEngine())
        ..init(false, AEADParameters(KeyParameter(key), 128, iv, Uint8List(0)));

      final output = Uint8List(cipher.getOutputSize(ciphertextAndTag.length));
      final len1 = cipher.processBytes(ciphertextAndTag, 0, ciphertextAndTag.length, output, 0);
      final len2 = cipher.doFinal(output, len1);
      final plaintextLength = len1 + len2;

      final plaintext = utf8.decode(output.sublist(0, plaintextLength));
      return jsonDecode(plaintext) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // --- Private helpers ---

  void _validatePin(String pin) {
    if (pin.length < 4 || pin.length > 6) {
      throw ArgumentError('PIN must be 4-6 digits');
    }
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      throw ArgumentError('PIN must contain only digits');
    }
  }

  Uint8List _generateRandom(int length) {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
  }

  Uint8List _hashPin(String pin, Uint8List salt) {
    final bytes = utf8.encode(pin);
    final combined = Uint8List(bytes.length + salt.length);
    combined.setRange(0, bytes.length, bytes);
    combined.setRange(bytes.length, combined.length, salt);
    return Uint8List.fromList(crypto.sha256.convert(combined).bytes);
  }

  /// Derive la cle dans un isolate (ne bloque pas l'UI)
  Future<Uint8List> _deriveKeyAsync(String pin, Uint8List salt) {
    return compute(_deriveKeyIsolate, _DeriveParams(pin, salt, _pbkdf2Iterations, _keyLength));
  }

  /// Top-level function pour l'isolate
  static Uint8List _deriveKeyIsolate(_DeriveParams p) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(p.salt, p.iterations, p.keyLength));
    return pbkdf2.process(utf8.encode(p.pin));
  }

  bool _constantTimeEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }
}

/// Params pour l'isolate PBKDF2
class _DeriveParams {
  final String pin;
  final Uint8List salt;
  final int iterations;
  final int keyLength;
  const _DeriveParams(this.pin, this.salt, this.iterations, this.keyLength);
}
