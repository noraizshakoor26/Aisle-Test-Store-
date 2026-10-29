import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/hero_slide.dart';

const String _cdn = 'https://cdn.dummyjson.com/product-images';

const List<
  ({String overline, String headline, String cta, String slug, List<String> images})
>
_slides = [
  (
    overline: 'THE PISTACHIO EDIT',
    headline: 'Skincare & scents for every day',
    cta: 'Shop beauty',
    slug: 'beauty',
    images: [
      '$_cdn/fragrances/chanel-coco-noir-eau-de/thumbnail.webp',
      '$_cdn/beauty/essence-mascara-lash-princess/thumbnail.webp',
      '$_cdn/beauty/eyeshadow-palette-with-mirror/thumbnail.webp',
    ],
  ),
  (
    overline: 'HOME, REIMAGINED',
    headline: 'Pieces that make a house feel lived-in',
    cta: 'Shop furniture',
    slug: 'furniture',
    images: [
      '$_cdn/furniture/annibale-colombo-sofa/thumbnail.webp',
      '$_cdn/furniture/knoll-saarinen-executive-conference-chair/thumbnail.webp',
      '$_cdn/furniture/bedside-table-african-cherry/thumbnail.webp',
    ],
  ),
  (
    overline: 'POCKET POWER',
    headline: 'The latest phones, ready to unbox',
    cta: 'Shop phones',
    slug: 'smartphones',
    images: [
      '$_cdn/smartphones/iphone-13-pro/thumbnail.webp',
      '$_cdn/smartphones/samsung-galaxy-s10/thumbnail.webp',
      '$_cdn/smartphones/oppo-f19-pro-plus/thumbnail.webp',
    ],
  ),
];

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key, required this.onSlideTap});

  final ValueChanged<String> onSlideTap;

  static const double height = 190;

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!_controller.hasClients) return;
      _controller.animateToPage(
        (_page + 1) % _slides.length,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    });
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _timer?.cancel();
    } else if (notification is ScrollEndNotification) {
      _startTimer();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 168,
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) {
                final slide = _slides[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => widget.onSlideTap(slide.slug),
                  child: HeroSlide(
                    overline: slide.overline,
                    headline: slide.headline,
                    cta: slide.cta,
                    images: slide.images,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: kScreenPadding,
          child: Row(
            children: [
              for (var i = 0; i < _slides.length; i++)
                AnimatedContainer(
                  duration: kStateDuration,
                  margin: const EdgeInsets.only(right: 6),
                  width: i == _page ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _page
                        ? AppColors.butter
                        : AppColors.onPrimary.withValues(alpha: 0.4),
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
