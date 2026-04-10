import 'package:flutter/material.dart';

/// Ecran d'accueil au premier lancement
/// Explique ce que fait l'app, puis redirige vers le PIN setup
class OnboardingScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const OnboardingScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1319),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo app
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset('assets/icons/ic_launcher.png', width: 80, height: 80),
              ),
              const SizedBox(height: 24),
              const Text(
                '-1+',
                style: TextStyle(
                  color: Color(0xFFE7EDF3),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Suivi d\'addictions',
                style: TextStyle(color: Color(0xFFA7B3BF), fontSize: 16),
              ),
              const Spacer(),
              // Features
              _buildFeature(Icons.timer_outlined, 'Suivi du temps', 'Travail, pauses, sommeil — tout est compte'),
              const SizedBox(height: 16),
              _buildFeature(Icons.smoking_rooms_outlined, 'Compteur clopes', 'Chaque cigarette est tracee'),
              const SizedBox(height: 16),
              // BUG+034 fix: drop the "chiffre" claim until BUG+018 (crypto
              // wiring) is resolved. The data IS local-only — that part is
              // true. The encryption claim was not; CryptoService is not
              // currently wired into data_store.
              _buildFeature(Icons.lock_outline, 'Donnees privees', 'Tout reste sur ton telephone'),
              const Spacer(),
              // CTA
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF35D99A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Commencer',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF0E1319)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF1A2330),
          ),
          child: Icon(icon, color: const Color(0xFF35D99A), size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFFE7EDF3), fontSize: 15, fontWeight: FontWeight.w600)),
              Text(subtitle, style: const TextStyle(color: Color(0xFFA7B3BF), fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
