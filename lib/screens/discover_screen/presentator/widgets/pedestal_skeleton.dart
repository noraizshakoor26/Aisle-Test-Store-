import 'package:flutter/material.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_shimmer.dart';
import 'package:test_store/core/widgets/aisle_skeleton_box.dart';

class PedestalSkeleton extends StatelessWidget {
  const PedestalSkeleton({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return AisleShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AisleSkeletonBox(width: width, height: width, radius: kRadiusTile),
          const SizedBox(height: 14),
          AisleSkeletonBox(width: width * 0.9, height: 14),
          const SizedBox(height: 8),
          AisleSkeletonBox(width: width * 0.6, height: 14),
          const SizedBox(height: 10),
          const AisleSkeletonBox(width: 56, height: 18),
        ],
      ),
    );
  }
}
