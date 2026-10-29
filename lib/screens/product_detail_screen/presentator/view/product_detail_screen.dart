import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/category_style.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/utils/utils.dart';
import 'package:test_store/core/widgets/aisle_chip.dart';
import 'package:test_store/core/widgets/aisle_rating_stars.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';
import 'package:test_store/screens/product_detail_screen/presentator/widgets/bento_tile.dart';
import 'package:test_store/screens/product_detail_screen/presentator/widgets/collapsed_header.dart';
import 'package:test_store/screens/product_detail_screen/presentator/widgets/detail_header_delegate.dart';
import 'package:test_store/screens/product_detail_screen/presentator/widgets/price_tag_card.dart';
import 'package:test_store/screens/product_detail_screen/presentator/widgets/product_gallery.dart';
import 'package:test_store/screens/product_detail_screen/presentator/widgets/rating_summary.dart';
import 'package:test_store/screens/product_detail_screen/presentator/widgets/review_card.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.heroTag,
  });

  final ProductModel product;
  final String heroTag;

  String get _overline {
    final category = product.category.replaceAll('-', ' ').toUpperCase();
    final brand = product.brand;
    return brand == null ? category : '${brand.toUpperCase()} · $category';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final padding = MediaQuery.paddingOf(context);
    final dimensions = product.dimensions;
    const gap = SizedBox(width: 12);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: DetailHeaderDelegate(
                topPadding: padding.top,
                tint: CategoryStyle.tintFor(product.category),
                gallery: ProductGallery(product: product, heroTag: heroTag),
                collapsedHeader: CollapsedHeader(
                  product: product,
                  topPadding: padding.top,
                ),
                onBack: () => Navigator.of(context).pop(),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                kGutter,
                4,
                kGutter,
                padding.bottom + 32,
              ),
              sliver: SliverList.list(
                children: [
                  Text(_overline, style: textTheme.labelSmall),
                  const SizedBox(height: 8),
                  Text(product.title, style: textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      AisleRatingStars(rating: product.rating),
                      const SizedBox(width: 8),
                      Text(
                        '${product.rating.toStringAsFixed(1)} · '
                        '${product.reviews.length} reviews',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PriceTagCard(product: product),
                  const SizedBox(height: 28),
                  Text('About', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: textTheme.bodyLarge!.copyWith(
                      color: AppColors.inkSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Details', style: textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: BentoTile(
                          icon: Icons.verified_user_outlined,
                          label: 'Warranty',
                          value: product.warrantyInformation,
                          tint: AppColors.tintMint,
                        ),
                      ),
                      gap,
                      Expanded(
                        child: BentoTile(
                          icon: Icons.local_shipping_outlined,
                          label: 'Shipping',
                          value: product.shippingInformation,
                          tint: AppColors.tintButter,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: BentoTile(
                          icon: Icons.assignment_return_outlined,
                          label: 'Returns',
                          value: product.returnPolicy,
                          tint: AppColors.tintBlush,
                        ),
                      ),
                      gap,
                      Expanded(
                        child: BentoTile(
                          icon: Icons.scale_outlined,
                          label: 'Weight',
                          value: Utils.formatNumber(product.weight),
                          tint: AppColors.tintSage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  BentoTile(
                    icon: Icons.straighten_rounded,
                    label: 'Dimensions',
                    value:
                        '${Utils.formatNumber(dimensions.width)} × '
                        '${Utils.formatNumber(dimensions.height)} × '
                        '${Utils.formatNumber(dimensions.depth)}',
                    tint: AppColors.tintSand,
                    trailing: 'SKU\n${product.sku}',
                  ),
                  if (product.reviews.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text('Reviews', style: textTheme.titleLarge),
                    const SizedBox(height: 12),
                    RatingSummary(product: product),
                    for (final review in product.reviews) ...[
                      const SizedBox(height: 12),
                      ReviewCard(review: review),
                    ],
                  ],
                  if (product.tags.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tag in product.tags) AisleChip(label: tag),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
