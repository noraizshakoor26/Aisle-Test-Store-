import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/category_style.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/utils/utils.dart';
import 'package:test_store/core/widgets/aisle_network_image.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';

class PedestalTile extends StatefulWidget {
  const PedestalTile({
    super.key,
    required this.product,
    required this.width,
    this.onTap,
  });

  final ProductModel product;
  final double width;
  final VoidCallback? onTap;

  static double heightFor(double width) => width + 12 + 40 + 4 + 24;

  @override
  State<PedestalTile> createState() => _PedestalTileState();
}

class _PedestalTileState extends State<PedestalTile> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final product = widget.product;
    final interactive = widget.onTap != null;

    return GestureDetector(
      onTapDown: interactive ? (_) => _setPressed(true) : null,
      onTapUp: interactive ? (_) => _setPressed(false) : null,
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: kMicroDuration,
        curve: Curves.easeOutCubic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: widget.width,
              height: widget.width,
              decoration: BoxDecoration(
                color: CategoryStyle.tintFor(product.category),
                borderRadius: BorderRadius.circular(kRadiusTile),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: 'grid-${product.id}',
                      child: AisleNetworkImage(
                        url: product.thumbnail,
                        cacheWidth: 400,
                        padding: const EdgeInsets.all(16),
                        radius: kRadiusTile,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(kRadiusChip),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: AppColors.star,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: textTheme.bodySmall!.copyWith(
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Utils.formatPrice(product.finalPrice),
              style: textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
