import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/utils/utils.dart';
import 'package:test_store/core/widgets/aisle_rating_stars.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final ReviewModel review;

  String get _initials => review.reviewerName
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final date = review.date;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tintSand,
        borderRadius: BorderRadius.circular(kRadiusTile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _initials,
                  style: textTheme.labelMedium!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                    if (date != null)
                      Text(
                        Utils.formatDate(date),
                        style: textTheme.bodySmall!.copyWith(
                          color: AppColors.inkTertiary,
                        ),
                      ),
                  ],
                ),
              ),
              AisleRatingStars(rating: review.rating.toDouble(), size: 12),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.comment, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
