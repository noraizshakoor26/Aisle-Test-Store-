import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';

class BentoTile extends StatelessWidget {
  const BentoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.tint,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color tint;
  final String? trailing;

  static const double height = 136;
  static const double wideHeight = 88;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final labelText = Text(
      label,
      style: textTheme.labelMedium!.copyWith(color: AppColors.inkSecondary),
    );
    final valueText = Text(
      value,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textTheme.titleMedium,
    );
    final iconWidget = Icon(icon, size: 24, color: AppColors.primary);
    final isWide = trailing != null;

    return Container(
      height: isWide ? wideHeight : height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(kRadiusTile),
      ),
      child: isWide
          ? Row(
              children: [
                iconWidget,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [labelText, const SizedBox(height: 4), valueText],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  trailing!,
                  textAlign: TextAlign.right,
                  style: textTheme.bodySmall!.copyWith(
                    color: AppColors.inkSecondary,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconWidget,
                const Spacer(),
                labelText,
                const SizedBox(height: 4),
                valueText,
              ],
            ),
    );
  }
}
