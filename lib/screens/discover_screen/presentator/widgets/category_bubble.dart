import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';

class CategoryBubble extends StatelessWidget {
  const CategoryBubble({
    super.key,
    required this.label,
    required this.icon,
    required this.tint,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color tint;
  final bool isSelected;
  final VoidCallback onTap;

  static const double width = 76;
  static const double _circle = 64;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            // The selection ring is two stacked shadows (a canvas gap, then the
            // pistachio ring) so selecting never changes the bubble's size.
            AnimatedContainer(
              duration: kStateDuration,
              width: _circle,
              height: _circle,
              decoration: BoxDecoration(
                color: tint,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? const [
                        BoxShadow(color: AppColors.primary, spreadRadius: 5),
                        BoxShadow(color: AppColors.canvas, spreadRadius: 3),
                      ]
                    : const [],
              ),
              child: Icon(
                icon,
                size: 26,
                color: isSelected ? AppColors.primary : AppColors.inkSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.labelMedium!.copyWith(
                color: isSelected ? AppColors.primary : AppColors.ink,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
