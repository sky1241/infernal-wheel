import 'package:flutter/material.dart';
import '../models/addiction.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // TODO: Charger depuis UserSettings
  List<AddictionType> _enabledAddictions = [
    AddictionType.tabac,
    AddictionType.alcoolBiere,
    AddictionType.alcoolVin,
    AddictionType.alcoolFort,
  ];
  double _sleepGoal = 8.0;
  bool _useHealthData = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          // Header
          Text(
            'Configuration',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: Spacing.xl),

          // Section Addictions
          _buildSectionHeader('Addictions a tracker'),
          const SizedBox(height: Spacing.sm),
          _buildAddictionsList(),
          const SizedBox(height: Spacing.xl),

          // Section Sommeil
          _buildSectionHeader('Sommeil'),
          const SizedBox(height: Spacing.sm),
          _buildSleepSettings(),
          const SizedBox(height: Spacing.xl),

          // Section Donnees
          _buildSectionHeader('Vie privee'),
          const SizedBox(height: Spacing.sm),
          _buildPrivacyInfo(),
          const SizedBox(height: Spacing.xl),

          // Version
          Center(
            child: Text(
              'InfernalWheel v1.0.0',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ),
          const SizedBox(height: Spacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildAddictionsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: AddictionType.values.asMap().entries.map((entry) {
          final index = entry.key;
          final type = entry.value;
          final isEnabled = _enabledAddictions.contains(type);
          final isLast = index == AddictionType.values.length - 1;

          return Column(
            children: [
              SwitchListTile(
                value: isEnabled,
                onChanged: (enabled) {
                  setState(() {
                    if (enabled) {
                      _enabledAddictions.add(type);
                    } else {
                      _enabledAddictions.remove(type);
                    }
                  });
                  // TODO: Sauvegarder
                },
                title: Row(
                  children: [
                    Text(type.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: Spacing.sm),
                    Text(type.label),
                  ],
                ),
                activeColor: type.color,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.xxs,
                ),
              ),
              if (!isLast) Divider(height: 1, color: AppColors.border),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSleepSettings() {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Objectif heures
          Row(
            children: [
              Expanded(
                child: Text('Objectif sommeil'),
              ),
              DropdownButton<double>(
                value: _sleepGoal,
                items: [6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0].map((h) {
                  final label = h == h.toInt()
                      ? '${h.toInt()}h'
                      : '${h.toInt()}h30';
                  return DropdownMenuItem(value: h, child: Text(label));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _sleepGoal = value);
                    // TODO: Sauvegarder
                  }
                },
                dropdownColor: AppColors.surface,
                underline: const SizedBox(),
              ),
            ],
          ),

          const Divider(height: Spacing.lg),

          // HealthKit toggle
          SwitchListTile(
            value: _useHealthData,
            onChanged: (value) {
              setState(() => _useHealthData = value);
              // TODO: Demander permissions si active
            },
            title: const Text('Utiliser la montre'),
            subtitle: Text(
              'Importer le sommeil automatiquement',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            activeColor: AppColors.accent,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyInfo() {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
            ),
            child: Icon(
              Icons.lock,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '100% local',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  'Tes donnees restent sur ton telephone. Rien n\'est envoye nulle part.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
