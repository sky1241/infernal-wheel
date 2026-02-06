import 'package:flutter/material.dart';
import '../../models/sleep_data.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class SleepCard extends StatelessWidget {
  final SleepData? sleep;
  final VoidCallback onTap;

  const SleepCard({
    super.key,
    this.sleep,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (sleep == null) {
      return _buildEmpty(context);
    }
    return _buildFilled(context, sleep!);
  }

  Widget _buildEmpty(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Spacing.radiusLg),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          children: [
            Icon(
              Icons.bedtime_outlined,
              size: Spacing.iconXl,
              color: AppColors.muted,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Pas de donnees sommeil',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Spacing.xxs),
            Text(
              'Touche pour saisir manuellement',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilled(BuildContext context, SleepData data) {
    final qualityColor = _getQualityColor(data.quality);

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient(qualityColor),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: qualityColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: qualityColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
            ),
            child: Icon(
              Icons.bedtime,
              color: qualityColor,
              size: Spacing.iconLg,
            ),
          ),
          const SizedBox(width: Spacing.md),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sommeil',
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Row(
                  children: [
                    _buildStat('Reveil', data.wakeTimeFormatted),
                    const SizedBox(width: Spacing.lg),
                    _buildStat('Duree', data.durationFormatted),
                  ],
                ),
              ],
            ),
          ),

          // Score
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: qualityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                child: Text(
                  '${data.quality.score}/10',
                  style: TextStyle(
                    color: qualityColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              Icon(
                _getSourceIcon(data.source),
                size: 14,
                color: AppColors.muted,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getQualityColor(SleepQuality quality) {
    switch (quality) {
      case SleepQuality.bad:
        return AppColors.sleepBad;
      case SleepQuality.poor:
        return AppColors.sleepPoor;
      case SleepQuality.okay:
        return AppColors.sleepOkay;
      case SleepQuality.good:
        return AppColors.sleepGood;
      case SleepQuality.great:
        return AppColors.sleepGreat;
    }
  }

  IconData _getSourceIcon(SleepSource source) {
    switch (source) {
      case SleepSource.healthKit:
        return Icons.watch; // Apple Watch
      case SleepSource.healthConnect:
        return Icons.watch; // Android watch
      case SleepSource.manual:
        return Icons.edit;
    }
  }
}
