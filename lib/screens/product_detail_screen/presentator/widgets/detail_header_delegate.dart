import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_circle_button.dart';

class DetailHeaderDelegate extends SliverPersistentHeaderDelegate {
  DetailHeaderDelegate({
    required this.topPadding,
    required this.tint,
    required this.gallery,
    required this.collapsedHeader,
    required this.onBack,
  });

  final double topPadding;
  final Color tint;
  final Widget gallery;
  final Widget collapsedHeader;
  final VoidCallback onBack;

  static const double _barHeight = 56;
  static const double _stageHeight = 440;
  static const double _capHeight = kRadiusSheet;

  @override
  double get minExtent => topPadding + _barHeight;

  @override
  double get maxExtent => topPadding + _stageHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final barOpacity = ((progress - 0.7) / 0.3).clamp(0.0, 1.0);

    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: tint)),
        // The gallery scrolls at half speed and shrinks slightly, so the
        // product sinks into the stage while the page slides over it.
        Positioned(
          top: topPadding + _barHeight - shrinkOffset * 0.5,
          left: 0,
          right: 0,
          height: _stageHeight - _barHeight - _capHeight - 8,
          child: Opacity(
            opacity: (1 - progress * 1.3).clamp(0.0, 1.0),
            child: Transform.scale(scale: 1 - 0.15 * progress, child: gallery),
          ),
        ),
        // The canvas cap at the bottom of the stage reads as the top of the
        // content sheet overlapping the stage.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: _capHeight,
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(kRadiusSheet * (1 - progress)),
              ),
            ),
            child: Opacity(
              opacity: (1 - progress * 2).clamp(0.0, 1.0),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: minExtent,
          child: IgnorePointer(
            ignoring: barOpacity == 0,
            child: Opacity(opacity: barOpacity, child: collapsedHeader),
          ),
        ),
        Positioned(
          top: topPadding + (_barHeight - kTapTarget) / 2,
          left: kGutter,
          child: AisleCircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: onBack,
          ),
        ),
        Positioned(
          top: topPadding + (_barHeight - kTapTarget) / 2,
          right: kGutter,
          child: IgnorePointer(
            child: Opacity(
              opacity: (1 - progress * 2).clamp(0.0, 1.0),
              child: const AisleCircleButton(icon: Icons.ios_share_rounded),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant DetailHeaderDelegate oldDelegate) => true;
}
