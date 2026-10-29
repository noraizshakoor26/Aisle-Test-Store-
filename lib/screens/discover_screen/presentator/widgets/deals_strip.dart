import 'package:flutter/material.dart';
import 'package:test_store/core/enums/status_indicator.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_shimmer.dart';
import 'package:test_store/core/widgets/aisle_skeleton_box.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/deal_card.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/inline_retry.dart';

class DealsStrip extends StatelessWidget {
  const DealsStrip({
    super.key,
    required this.deals,
    required this.status,
    required this.onRetry,
    this.onDealTap,
  });

  final List<ProductModel> deals;
  final StatusIndicator status;
  final VoidCallback onRetry;
  final ValueChanged<ProductModel>? onDealTap;

  @override
  Widget build(BuildContext context) {
    if (status == StatusIndicator.failed) {
      return SizedBox(
        height: DealCard.height,
        child: Center(
          child: InlineRetry(message: "Couldn't load deals", onRetry: onRetry),
        ),
      );
    }

    final isLoading = deals.isEmpty;
    return SizedBox(
      height: DealCard.height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: kScreenPadding,
        physics: isLoading ? const NeverScrollableScrollPhysics() : null,
        itemCount: isLoading ? 2 : deals.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (isLoading) {
            return const AisleShimmer(
              child: AisleSkeletonBox(
                width: DealCard.width,
                height: DealCard.height,
                radius: kRadiusTile,
              ),
            );
          }
          final deal = deals[index];
          return DealCard(
            product: deal,
            onTap: onDealTap == null ? null : () => onDealTap!(deal),
          );
        },
      ),
    );
  }
}
