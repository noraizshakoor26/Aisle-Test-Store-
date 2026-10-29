import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';

class SocialButton extends StatefulWidget {
  const SocialButton({
    super.key,
    required this.label,
    required this.logo,
    required this.onPressed,
  });

  final String label;
  final Widget logo;
  final VoidCallback onPressed;

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: kMicroDuration,
        curve: Curves.easeOutCubic,
        child: Container(
          height: kControlHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadiusControl),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.logo,
              const SizedBox(width: 8),
              Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
