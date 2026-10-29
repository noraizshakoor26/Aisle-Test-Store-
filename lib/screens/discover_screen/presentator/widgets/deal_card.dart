import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/utils/utils.dart';
import 'package:test_store/core/widgets/aisle_network_image.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';

class DealCard extends StatelessWidget {
  const DealCard({super.key, required this.product, this.onTap});

  final ProductModel product;
  final VoidCallback? onTap;

  static const double width = 296;
  static const double height = 148;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.plum,
          borderRadius: BorderRadius.circular(kRadiusTile),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              bottom: 16,
              right: 4,
              width: 132,
              child: Hero(
                tag: 'deal-${product.id}',
                child: AisleNetworkImage(
                  url: product.thumbnail,
                  cacheWidth: 300,
                  padding: const EdgeInsets.all(8),
                  radius: kRadiusControl,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DEAL',
                    style: textTheme.labelSmall!.copyWith(
                      color: AppColors.butter,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge!.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    Utils.formatPrice(product.finalPrice),
                    style: textTheme.titleMedium!.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                  Text(
                    Utils.formatPrice(product.price),
                    style: textTheme.bodySmall!.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.6),
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.onPrimary.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.butter,
                  borderRadius: BorderRadius.circular(kRadiusSmall),
                ),
                child: Text(
                  '−${product.discountPercentage.round()}%',
                  style: textTheme.titleMedium!.copyWith(
                    fontSize: 13,
                    height: 16 / 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.plum,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
