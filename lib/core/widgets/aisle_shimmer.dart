import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';

class AisleShimmer extends StatefulWidget {
  const AisleShimmer({super.key, required this.child});

  final Widget child;

  @override
  State<AisleShimmer> createState() => _AisleShimmerState();
}

class _AisleShimmerState extends State<AisleShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final shift = _controller.value * 3 - 1;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(shift - 1, -0.3),
            end: Alignment(shift + 1, 0.3),
            colors: const [
              AppColors.surfaceSunken,
              Color(0xFFF7F1E6),
              AppColors.surfaceSunken,
            ],
            stops: const [0.35, 0.5, 0.65],
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}
