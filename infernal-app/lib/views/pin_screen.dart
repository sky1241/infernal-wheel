import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../security/crypto_service.dart';

/// Ecran de saisie du PIN (setup ou unlock)
class PinScreen extends StatefulWidget {
  final bool isSetup; // true = premier lancement, false = deverrouillage
  final VoidCallback onSuccess;

  const PinScreen({super.key, required this.isSetup, required this.onSuccess});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _crypto = CryptoService();
  String _pin = '';
  String? _confirmPin; // pour le setup, on demande 2 fois
  String? _error;
  bool _isProcessing = false;
  bool _isConfirmStep = false;

  int get _maxDigits => 6;
  int get _minDigits => 4;

  void _addDigit(String digit) {
    if (_pin.length >= _maxDigits) return;
    setState(() {
      _pin += digit;
      _error = null;
    });
    HapticFeedback.lightImpact();

    // Auto-submit quand on a assez de chiffres et qu'on appuie le dernier
    // Non — on laisse l'utilisateur choisir entre 4, 5 ou 6 chiffres
  }

  void _removeDigit() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = null;
    });
    HapticFeedback.lightImpact();
  }

  Future<void> _submit() async {
    if (_pin.length < _minDigits) {
      setState(() => _error = 'Minimum $_minDigits chiffres');
      return;
    }

    setState(() => _isProcessing = true);

    if (widget.isSetup) {
      if (!_isConfirmStep) {
        // Premiere saisie — passer a la confirmation
        setState(() {
          _confirmPin = _pin;
          _pin = '';
          _isConfirmStep = true;
          _isProcessing = false;
        });
        return;
      }

      // Confirmation — verifier que les 2 PIN sont identiques
      if (_pin != _confirmPin) {
        setState(() {
          _error = 'Les codes ne correspondent pas';
          _pin = '';
          _confirmPin = null;
          _isConfirmStep = false;
          _isProcessing = false;
        });
        HapticFeedback.heavyImpact();
        return;
      }

      // Setup le PIN
      try {
        await _crypto.setup(_pin);
        widget.onSuccess();
      } catch (e) {
        setState(() {
          _error = 'Erreur: $e';
          _isProcessing = false;
        });
      }
    } else {
      // Deverrouillage
      final ok = await _crypto.unlock(_pin);
      if (ok) {
        widget.onSuccess();
      } else {
        setState(() {
          _error = 'Code incorrect';
          _pin = '';
          _isProcessing = false;
        });
        HapticFeedback.heavyImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1319),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Logo / titre
            const Icon(Icons.local_fire_department, color: Color(0xFF35D99A), size: 48),
            const SizedBox(height: 16),
            Text(
              widget.isSetup ? '-1+' : 'Deverrouillage',
              style: const TextStyle(
                color: Color(0xFFE7EDF3),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getSubtitle(),
              style: const TextStyle(color: Color(0xFFA7B3BF), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Dots indicator
            _buildDots(),
            const SizedBox(height: 8),
            // Error
            SizedBox(
              height: 24,
              child: _error != null
                  ? Text(_error!, style: const TextStyle(color: Color(0xFFFF7A7A), fontSize: 13))
                  : null,
            ),
            const Spacer(),
            // Numpad
            _buildNumpad(),
            const SizedBox(height: 16),
            // Submit button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _pin.length >= _minDigits && !_isProcessing ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF35D99A),
                    disabledBackgroundColor: const Color(0xFF1A2330),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isProcessing
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(
                          _isConfirmStep ? 'Confirmer' : (widget.isSetup ? 'Suivant' : 'Deverrouiller'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0E1319)),
                        ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  String _getSubtitle() {
    if (widget.isSetup) {
      return _isConfirmStep
          ? 'Confirmez votre code'
          : 'Choisissez un code PIN (4-6 chiffres)\npour proteger vos donnees';
    }
    return 'Entrez votre code PIN';
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_maxDigits, (i) {
        final filled = i < _pin.length;
        final active = i < _maxDigits && i >= _minDigits - 1;
        return Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? const Color(0xFF35D99A) : Colors.transparent,
            border: Border.all(
              color: filled
                  ? const Color(0xFF35D99A)
                  : (active ? const Color(0xFF3A4553) : const Color(0xFF242D38)),
              width: 2,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumpad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 12),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 12),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 12),
          _buildRow(['', '0', 'del']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key.isEmpty) return const SizedBox(width: 72, height: 56);
        if (key == 'del') {
          return SizedBox(
            width: 72,
            height: 56,
            child: IconButton(
              onPressed: _pin.isNotEmpty ? _removeDigit : null,
              icon: Icon(
                Icons.backspace_outlined,
                color: _pin.isNotEmpty ? const Color(0xFFE7EDF3) : const Color(0xFF3A4553),
              ),
            ),
          );
        }
        return SizedBox(
          width: 72,
          height: 56,
          child: TextButton(
            onPressed: () => _addDigit(key),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: const Color(0xFF1A2330),
            ),
            child: Text(
              key,
              style: const TextStyle(color: Color(0xFFE7EDF3), fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    );
  }
}
