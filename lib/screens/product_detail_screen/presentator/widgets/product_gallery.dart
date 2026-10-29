import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_network_image.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';

class ProductGallery extends StatefulWidget {
  const ProductGallery({
    super.key,
    required this.product,
    required this.heroTag,
  });

  final ProductModel product;
  final String heroTag;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  static const EdgeInsets _imagePadding = EdgeInsets.all(32);

  int _page = 0;

  int get _pageCount =>
      widget.product.images.isEmpty ? 1 : widget.product.images.length;

  Widget _firstPage() {
    final product = widget.product;
    // The cached 300px thumbnail shows instantly and is what flies in from
    // the grid; the sharp 1000px image then fades in over it, no skeleton.
    return Hero(
      tag: widget.heroTag,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AisleNetworkImage(
            url: product.thumbnail,
            cacheWidth: 400,
            padding: _imagePadding,
            radius: kRadiusTile,
          ),
          if (product.images.isNotEmpty)
            AisleNetworkImage(
              url: product.images.first,
              cacheWidth: 1000,
              padding: _imagePadding,
              showSkeleton: false,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: _pageCount,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) {
              if (index == 0) return _firstPage();
              return AisleNetworkImage(
                url: widget.product.images[index],
                cacheWidth: 1000,
                padding: _imagePadding,
                radius: kRadiusTile,
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 6,
          child: _pageCount < 2
              ? null
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _pageCount; i++)
                      AnimatedContainer(
                        duration: kStateDuration,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _page ? 18 : 6,
                        decoration: BoxDecoration(
                          color: AppColors.ink.withValues(
                            alpha: i == _page ? 1 : 0.25,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
