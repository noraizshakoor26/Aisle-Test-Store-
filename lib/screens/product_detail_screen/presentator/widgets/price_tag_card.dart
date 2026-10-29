import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/utils/utils.dart';
import 'package:test_store/core/widgets/aisle_chip.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';

class PriceTagCard extends StatelessWidget {
  const PriceTagCard({super.key, required this.product});

  final ProductModel product;

  AisleChip _stockChip() {
    switch (product.availabilityStatus) {
      case 'Out of Stock':
        return AisleChip(
          label: 'Out of stock',
          foreground: AppColors.danger,
          background: AppColors.danger.withValues(alpha: 0.1),
          showDot: true,
        );
      case 'Low Stock':
        return AisleChip(
          label: 'Low stock · ${product.stock} left',
          foreground: AppColors.warning,
          background: AppColors.warning.withValues(alpha: 0.12),
          showDot: true,
        );
      default:
        return AisleChip(
          label: 'In stock · ${product.stock} left',
          foreground: AppColors.primary,
          background: AppColors.primarySoft,
          showDot: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasDiscount = product.discountPercentage >= 1;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.tintMint,
        borderRadius: BorderRadius.circular(kRadiusTile),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: hasDiscount ? 84 : 0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 10,
                    children: [
                      Text(
                        Utils.formatPrice(product.finalPrice),
                        style: textTheme.headlineLarge,
                      ),
                      if (hasDiscount)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            Utils.formatPrice(product.price),
                            style: textTheme.bodyLarge!.copyWith(
                              color: AppColors.inkTertiary,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.inkTertiary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _stockChip(),
              ],
            ),
          ),
          if (hasDiscount)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                decoration: const BoxDecoration(
                  color: AppColors.plum,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(kRadiusChip),
                  ),
                ),
                child: Text(
                  'Save ${product.discountPercentage.round()}%',
                  style: textTheme.labelMedium!.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
