import 'package:flutter/material.dart';
import 'package:test_store/core/enums/status_indicator.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/category_style.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_shimmer.dart';
import 'package:test_store/core/widgets/aisle_skeleton_box.dart';
import 'package:test_store/screens/discover_screen/data/models/category_model.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/category_bubble.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/inline_retry.dart';

class CategoryStrip extends StatelessWidget {
  const CategoryStrip({
    super.key,
    required this.categories,
    required this.status,
    required this.selectedSlug,
    required this.onSelected,
    required this.onRetry,
  });

  final List<CategoryModel> categories;
  final StatusIndicator status;
  final String? selectedSlug;
  final ValueChanged<String?> onSelected;
  final VoidCallback onRetry;

  static const double _height = 104;

  @override
  Widget build(BuildContext context) {
    if (status == StatusIndicator.failed) {
      return SizedBox(
        height: _height,
        child: Center(
          child: InlineRetry(
            message: "Couldn't load categories",
            onRetry: onRetry,
          ),
        ),
      );
    }

    final isLoading = categories.isEmpty;
    return SizedBox(
      height: _height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: kGutter, vertical: 6),
        physics: isLoading ? const NeverScrollableScrollPhysics() : null,
        itemCount: isLoading ? 6 : categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (isLoading) {
            return const AisleShimmer(
              child: SizedBox(
                width: CategoryBubble.width,
                child: Column(
                  children: [
                    AisleSkeletonBox(
                      width: 64,
                      height: 64,
                      shape: BoxShape.circle,
                    ),
                    SizedBox(height: 12),
                    AisleSkeletonBox(width: 48, height: 12),
                  ],
                ),
              ),
            );
          }
          if (index == 0) {
            return CategoryBubble(
              label: 'All',
              icon: Icons.auto_awesome_outlined,
              tint: AppColors.primarySoft,
              isSelected: selectedSlug == null,
              onTap: () => onSelected(null),
            );
          }
          final category = categories[index - 1];
          return CategoryBubble(
            label: category.name,
            icon: CategoryStyle.iconFor(category.slug),
            tint: CategoryStyle.tintFor(category.slug),
            isSelected: selectedSlug == category.slug,
            onTap: () => onSelected(category.slug),
          );
        },
      ),
    );
  }
}
