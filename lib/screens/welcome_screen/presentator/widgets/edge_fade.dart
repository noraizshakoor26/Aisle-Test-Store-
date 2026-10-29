import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';

class EdgeFade extends StatelessWidget {
  const EdgeFade({super.key, required this.fadeDown});

  final bool fadeDown;

  @override
  Widget build(BuildContext context) {
    final colors = [AppColors.canvas, AppColors.canvas.withValues(alpha: 0)];
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: fadeDown ? colors : colors.reversed.toList(),
          ),
        ),
      ),
    );
  }
}
