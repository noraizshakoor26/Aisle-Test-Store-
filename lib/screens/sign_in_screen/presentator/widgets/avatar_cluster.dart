import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/widgets/aisle_network_image.dart';

const String _cdn = 'https://cdn.dummyjson.com/product-images';

const List<({String image, Color tint})> _bubbles = [
  (
    image: '$_cdn/beauty/essence-mascara-lash-princess/thumbnail.webp',
    tint: AppColors.tintMint,
  ),
  (
    image: '$_cdn/fragrances/calvin-klein-ck-one/thumbnail.webp',
    tint: AppColors.tintBlush,
  ),
  (
    image: '$_cdn/mens-watches/rolex-submariner-watch/thumbnail.webp',
    tint: AppColors.tintButter,
  ),
];

class AvatarCluster extends StatelessWidget {
  const AvatarCluster({super.key});

  static const double _size = 48;
  static const double _overlap = 12;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size * _bubbles.length - _overlap * (_bubbles.length - 1),
      height: _size,
      child: Stack(
        children: [
          for (var i = 0; i < _bubbles.length; i++)
            Positioned(
              left: i * (_size - _overlap),
              child: Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  color: _bubbles[i].tint,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.canvas, width: 2),
                ),
                child: ClipOval(
                  child: AisleNetworkImage(
                    url: _bubbles[i].image,
                    cacheWidth: 150,
                    padding: const EdgeInsets.all(8),
                    radius: _size / 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
