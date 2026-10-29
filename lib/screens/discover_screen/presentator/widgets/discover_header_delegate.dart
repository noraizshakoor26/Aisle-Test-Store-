import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/hero_carousel.dart';

class DiscoverHeaderDelegate extends SliverPersistentHeaderDelegate {
  DiscoverHeaderDelegate({
    required this.topPadding,
    required this.greeting,
    required this.search,
    required this.hero,
  });

  final double topPadding;
  final Widget greeting;
  final Widget search;
  final Widget hero;

  static const double _greetingHeight = 48;

  double get _searchTop => topPadding + 12 + _greetingHeight + 16;
  double get _heroTop => _searchTop + kControlHeight + 24;

  @override
  double get minExtent => topPadding + 12 + kControlHeight + 12;

  @override
  double get maxExtent => _heroTop + HeroCarousel.height + 32;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(kRadiusSheet),
      ),
      child: ColoredBox(
        color: AppColors.primaryDeep,
        child: Stack(
          children: [
            // The hero drifts up at half the scroll speed, so it slides under
            // the shrinking header instead of moving with it.
            Positioned(
              top: _heroTop - shrinkOffset * 0.5,
              left: 0,
              right: 0,
              height: HeroCarousel.height,
              child: IgnorePointer(
                ignoring: progress > 0.4,
                child: Opacity(
                  opacity: (1 - progress * 1.6).clamp(0.0, 1.0),
                  child: hero,
                ),
              ),
            ),
            Positioned(
              top: topPadding + 12 - shrinkOffset,
              left: kGutter,
              right: kGutter,
              height: _greetingHeight,
              child: Opacity(
                opacity: (1 - shrinkOffset / _greetingHeight).clamp(0.0, 1.0),
                child: greeting,
              ),
            ),
            Positioned(
              top: math.max(topPadding + 12, _searchTop - shrinkOffset),
              left: kGutter,
              right: kGutter,
              height: kControlHeight,
              child: search,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant DiscoverHeaderDelegate oldDelegate) => true;
}
