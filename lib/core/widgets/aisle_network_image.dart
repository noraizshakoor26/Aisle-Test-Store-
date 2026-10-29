import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';

class AisleNetworkImage extends StatelessWidget {
  const AisleNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
    this.cacheWidth,
  });

  final String url;
  final BoxFit fit;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      cacheWidth: cacheWidth,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: kStateDuration,
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 24,
          color: AppColors.inkTertiary,
        ),
      ),
    );
  }
}
