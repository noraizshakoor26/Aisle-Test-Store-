import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_shimmer.dart';
import 'package:test_store/core/widgets/aisle_skeleton_box.dart';

class AisleNetworkImage extends StatelessWidget {
  const AisleNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
    this.padding = EdgeInsets.zero,
    this.radius = 0,
    this.cacheWidth,
    this.showSkeleton = true,
  });

  final String url;
  final BoxFit fit;
  final EdgeInsets padding;
  final double radius;
  final int? cacheWidth;
  final bool showSkeleton;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      memCacheWidth: cacheWidth,
      fadeInDuration: kStateDuration,
      fadeOutDuration: kStateDuration,
      fadeInCurve: Curves.easeOut,
      imageBuilder: (context, imageProvider) => Padding(
        padding: padding,
        child: Image(image: imageProvider, fit: fit),
      ),
      placeholder: (context, url) => showSkeleton
          ? AisleShimmer(child: AisleSkeletonBox(radius: radius))
          : const SizedBox.shrink(),
      errorWidget: (context, url, error) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 24,
          color: AppColors.inkTertiary,
        ),
      ),
    );
  }
}
