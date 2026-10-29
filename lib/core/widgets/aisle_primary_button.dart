import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';

class AislePrimaryButton extends StatefulWidget {
  const AislePrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? trailingIcon;

  @override
  State<AislePrimaryButton> createState() => _AislePrimaryButtonState();
}

class _AislePrimaryButtonState extends State<AislePrimaryButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(
      context,
    ).textTheme.labelLarge!.copyWith(color: AppColors.onPrimary);

    return GestureDetector(
      onTapDown: _enabled ? (_) => _setPressed(true) : null,
      onTapUp: _enabled ? (_) => _setPressed(false) : null,
      onTapCancel: () => _setPressed(false),
      onTap: _enabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: kMicroDuration,
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: widget.onPressed == null && !widget.isLoading ? 0.3 : 1,
          duration: kStateDuration,
          child: Container(
            height: kControlHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(kRadiusControl),
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: kStateDuration,
              child: widget.isLoading
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : Row(
                      key: const ValueKey('label'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.label, style: labelStyle),
                        if (widget.trailingIcon != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            widget.trailingIcon,
                            size: 18,
                            color: AppColors.onPrimary,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
