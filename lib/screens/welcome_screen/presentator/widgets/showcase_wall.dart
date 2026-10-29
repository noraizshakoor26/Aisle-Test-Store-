import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/screens/welcome_screen/presentator/widgets/edge_fade.dart';
import 'package:test_store/screens/welcome_screen/presentator/widgets/showcase_card.dart';

typedef _ShowcaseItem = ({
  String title,
  String brand,
  String image,
  Color tint,
});

const String _cdn = 'https://cdn.dummyjson.com/product-images';

const List<_ShowcaseItem> _leftItems = [
  (
    title: 'Essence Mascara Lash Princess',
    brand: 'Essence',
    image: '$_cdn/beauty/essence-mascara-lash-princess/thumbnail.webp',
    tint: AppColors.tintBlush,
  ),
  (
    title: 'Calvin Klein CK One',
    brand: 'Calvin Klein',
    image: '$_cdn/fragrances/calvin-klein-ck-one/thumbnail.webp',
    tint: AppColors.tintButter,
  ),
  (
    title: 'Knoll Saarinen Executive Chair',
    brand: 'Knoll',
    image:
        '$_cdn/furniture/knoll-saarinen-executive-conference-chair/thumbnail.webp',
    tint: AppColors.tintSand,
  ),
  (
    title: 'Prada Women Bag',
    brand: 'Prada',
    image: '$_cdn/womens-bags/prada-women-bag/thumbnail.webp',
    tint: AppColors.tintBlush,
  ),
];

const List<_ShowcaseItem> _rightItems = [
  (
    title: 'Red Lipstick',
    brand: 'Chic Cosmetics',
    image: '$_cdn/beauty/red-lipstick/thumbnail.webp',
    tint: AppColors.tintBlush,
  ),
  (
    title: 'Annibale Colombo Sofa',
    brand: 'Annibale Colombo',
    image: '$_cdn/furniture/annibale-colombo-sofa/thumbnail.webp',
    tint: AppColors.tintSand,
  ),
  (
    title: 'Rolex Submariner Watch',
    brand: 'Rolex',
    image: '$_cdn/mens-watches/rolex-submariner-watch/thumbnail.webp',
    tint: AppColors.tintButter,
  ),
  (
    title: 'Black Sun Glasses',
    brand: 'Fashion Shades',
    image: '$_cdn/sunglasses/black-sun-glasses/thumbnail.webp',
    tint: AppColors.tintSand,
  ),
];

class ShowcaseWall extends StatefulWidget {
  const ShowcaseWall({super.key});

  @override
  State<ShowcaseWall> createState() => _ShowcaseWallState();
}

class _ShowcaseWallState extends State<ShowcaseWall>
    with SingleTickerProviderStateMixin {
  static const double _gap = 12;
  static const double _stagger = 48;
  static const double _pixelsPerSecond = 12;

  final _seconds = ValueNotifier<double>(0);
  late final Ticker _ticker = createTicker(
    (elapsed) => _seconds.value = elapsed.inMicroseconds / 1e6,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion && _ticker.isActive) _ticker.stop();
    if (!reduceMotion && !_ticker.isActive) _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _seconds.dispose();
    super.dispose();
  }

  Widget _column(List<_ShowcaseItem> items, double width) {
    // Two copies back to back, so wrapping the offset at one cycle is seamless.
    final cards = [...items, ...items];
    return Column(
      children: [
        for (final item in cards)
          Padding(
            padding: const EdgeInsets.only(bottom: _gap),
            child: ShowcaseCard(
              title: item.title,
              brand: item.brand,
              imageUrl: item.image,
              tint: item.tint,
              width: width,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnWidth = (constraints.maxWidth - kGutter * 2 - _gap) / 2;
        final cycle =
            _leftItems.length * (ShowcaseCard.heightFor(columnWidth) + _gap);
        final leftColumn = _column(_leftItems, columnWidth);
        final rightColumn = _column(_rightItems, columnWidth);

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: _seconds,
              builder: (context, seconds, _) {
                final travelled = seconds * _pixelsPerSecond;
                final leftShift = -(travelled % cycle);
                final rightShift = ((travelled + _stagger) % cycle) - cycle;
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: kGutter,
                      width: columnWidth,
                      child: Transform.translate(
                        offset: Offset(0, leftShift),
                        child: leftColumn,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: kGutter,
                      width: columnWidth,
                      child: Transform.translate(
                        offset: Offset(0, rightShift),
                        child: rightColumn,
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: MediaQuery.paddingOf(context).top,
              child: const ColoredBox(color: AppColors.canvas),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.paddingOf(context).top,
              height: 32,
              child: const EdgeFade(fadeDown: true),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 80,
              child: EdgeFade(fadeDown: false),
            ),
          ],
        );
      },
    );
  }
}
