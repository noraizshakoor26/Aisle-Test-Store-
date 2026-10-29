import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_rating_stars.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';

class RatingSummary extends StatelessWidget {
  const RatingSummary({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final reviews = product.reviews;
    final counts = List<int>.filled(5, 0);
    for (final review in reviews) {
      if (review.rating >= 1 && review.rating <= 5) counts[review.rating - 1]++;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kRadiusTile),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                product.rating.toStringAsFixed(1),
                style: textTheme.displayLarge,
              ),
              const SizedBox(height: 6),
              AisleRatingStars(rating: product.rating),
              const SizedBox(height: 6),
              Text(
                '${reviews.length} ${reviews.length == 1 ? 'review' : 'reviews'}',
                style: textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                for (var star = 5; star >= 1; star--)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                          child: Text('$star', style: textTheme.bodySmall),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: reviews.isEmpty
                                  ? 0
                                  : counts[star - 1] / reviews.length,
                              minHeight: 6,
                              color: AppColors.primary,
                              backgroundColor: AppColors.surfaceSunken,
                            ),
                          ),
                        ),
                      ],
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
