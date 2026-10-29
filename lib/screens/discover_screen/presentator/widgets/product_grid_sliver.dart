import 'package:flutter/material.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/pedestal_skeleton.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/pedestal_tile.dart';

class ProductGridSliver extends StatelessWidget {
  const ProductGridSliver({
    super.key,
    required this.products,
    required this.isLoading,
    this.onProductTap,
  });

  final List<ProductModel> products;
  final bool isLoading;
  final ValueChanged<ProductModel>? onProductTap;

  static const double _columnGap = 12;
  static const int _skeletonCount = 6;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: kScreenPadding,
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final tileWidth = (constraints.crossAxisExtent - _columnGap) / 2;
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: _columnGap,
              mainAxisSpacing: 24,
              mainAxisExtent: PedestalTile.heightFor(tileWidth),
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (isLoading) return PedestalSkeleton(width: tileWidth);
                final product = products[index];
                return PedestalTile(
                  product: product,
                  width: tileWidth,
                  onTap: onProductTap == null
                      ? null
                      : () => onProductTap!(product),
                );
              },
              childCount: isLoading ? _skeletonCount : products.length,
            ),
          );
        },
      ),
    );
  }
}
