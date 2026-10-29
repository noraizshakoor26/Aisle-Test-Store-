import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/category_style.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/utils/utils.dart';
import 'package:test_store/core/widgets/aisle_network_image.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';

class CollapsedHeader extends StatelessWidget {
  const CollapsedHeader({
    super.key,
    required this.product,
    required this.topPadding,
  });

  final ProductModel product;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            top: topPadding,
            left: kGutter + kTapTarget + 12,
            right: kGutter,
          ),
          decoration: BoxDecoration(
            color: AppColors.canvas.withValues(alpha: 0.92),
            border: const Border(bottom: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: CategoryStyle.tintFor(product.category),
                  borderRadius: BorderRadius.circular(kRadiusChip),
                ),
                child: AisleNetworkImage(
                  url: product.thumbnail,
                  cacheWidth: 120,
                  padding: const EdgeInsets.all(3),
                  radius: kRadiusChip,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                Utils.formatPrice(product.finalPrice),
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
