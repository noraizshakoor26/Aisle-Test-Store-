import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';

class AisleRatingStars extends StatelessWidget {
  const AisleRatingStars({super.key, required this.rating, this.size = 14});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = rating >= index + 1;
        final half = !filled && rating >= index + 0.5;
        return Stack(
          children: [
            Icon(
              Icons.star_rounded,
              size: size,
              color: filled
                  ? AppColors.star
                  : AppColors.inkTertiary.withValues(alpha: 0.35),
            ),
            if (half)
              Icon(Icons.star_half_rounded, size: size, color: AppColors.star),
          ],
        );
      }),
    );
  }
}
