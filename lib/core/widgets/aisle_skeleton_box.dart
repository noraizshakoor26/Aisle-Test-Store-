import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';

class AisleSkeletonBox extends StatelessWidget {
  const AisleSkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius = 6,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final double radius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceSunken,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(radius),
      ),
    );
  }
}
