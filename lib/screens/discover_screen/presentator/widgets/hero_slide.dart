import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_network_image.dart';

class HeroSlide extends StatelessWidget {
  const HeroSlide({
    super.key,
    required this.overline,
    required this.headline,
    required this.cta,
    required this.images,
  });

  final String overline;
  final String headline;
  final String cta;
  final List<String> images;

  Widget _image(int index) => AisleNetworkImage(
    url: images[index],
    cacheWidth: 300,
    radius: kRadiusControl,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: kScreenPadding,
      child: Row(
        children: [
          Expanded(
            flex: 11,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overline,
                  style: textTheme.labelSmall!.copyWith(
                    color: AppColors.butter,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  headline,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.displaySmall!.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      cta,
                      style: textTheme.titleSmall!.copyWith(
                        color: AppColors.butter,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: AppColors.butter,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 9,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      width: width * 0.62,
                      height: width * 0.62,
                      child: Transform.rotate(angle: 0.12, child: _image(0)),
                    ),
                    Positioned(
                      top: height * 0.3,
                      left: 0,
                      width: width * 0.66,
                      height: width * 0.66,
                      child: Transform.rotate(angle: -0.1, child: _image(1)),
                    ),
                    Positioned(
                      bottom: 0,
                      right: width * 0.04,
                      width: width * 0.56,
                      height: width * 0.56,
                      child: Transform.rotate(angle: 0.05, child: _image(2)),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
