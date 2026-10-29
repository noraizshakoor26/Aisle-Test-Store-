import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_network_image.dart';

class ShowcaseCard extends StatelessWidget {
  const ShowcaseCard({
    super.key,
    required this.title,
    required this.brand,
    required this.imageUrl,
    required this.tint,
    required this.width,
  });

  final String title;
  final String brand;
  final String imageUrl;
  final Color tint;
  final double width;

  static double heightFor(double width) => width + 54;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: width,
      height: heightFor(width),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(kRadiusTile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width - 16,
            height: width - 16,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(kRadiusSmall),
            ),
            child: AisleNetworkImage(
              url: imageUrl,
              cacheWidth: 400,
              padding: const EdgeInsets.all(16),
              radius: kRadiusSmall,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  brand,
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
