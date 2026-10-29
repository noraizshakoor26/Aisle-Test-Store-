import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';

class AisleWordmark extends StatelessWidget {
  const AisleWordmark({super.key, this.fontSize = 20, this.onDark = false});

  final double fontSize;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'aisle',
        children: [
          TextSpan(
            text: '.',
            style: TextStyle(color: onDark ? AppColors.butter : AppColors.plum),
          ),
        ],
      ),
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
        fontSize: fontSize,
        height: 1,
        letterSpacing: -1,
        color: onDark ? AppColors.onPrimary : AppColors.ink,
      ),
    );
  }
}
