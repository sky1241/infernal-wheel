import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/addiction.dart';
import '../../models/day_entry.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class AddictionCard extends StatelessWidget {
  final AddictionType type;
  final int count;
  final Trend trend;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const AddictionCard({
    super.key,
    required this.type,
    required this.count,
    required this.trend,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient(type.color),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: type.borderColor, width: 1),
      ),
      child: Row(
        children: [
          // Emoji + Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  type.label,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Compteur + Trend
          Row(
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              _buildTrend(),
            ],
          ),

          const SizedBox(width: Spacing.md),

          // Boutons +/-
          Row(
            children: [
              _buildButton(
                icon: Icons.remove,
                onTap: count > 0 ? onDecrement : null,
                enabled: count > 0,
              ),
              const SizedBox(width: Spacing.xs),
              _buildButton(
                icon: Icons.add,
                onTap: onIncrement,
                enabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrend() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: Color(trend.colorValue).withOpacity(0.15),
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
      ),
      child: Text(
        trend.symbol,
        style: TextStyle(
          color: Color(trend.colorValue),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool enabled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () {
          HapticFeedback.lightImpact();
          onTap?.call();
        } : null,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        child: Container(
          width: Spacing.touchTarget,
          height: Spacing.touchTarget,
          decoration: BoxDecoration(
            color: enabled
                ? type.color.withOpacity(0.15)
                : AppColors.border.withOpacity(0.3),
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            border: Border.all(
              color: enabled ? type.color.withOpacity(0.4) : AppColors.border,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: enabled ? type.color : AppColors.muted,
            size: Spacing.iconMd,
          ),
        ),
      ),
    );
  }
}
