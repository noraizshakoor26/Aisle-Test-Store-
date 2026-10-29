import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';

class AisleTextField extends StatefulWidget {
  const AisleTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.isPassword = false,
    this.hasError = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool isPassword;
  final bool hasError;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AisleTextField> createState() => _AisleTextFieldState();
}

class _AisleTextFieldState extends State<AisleTextField> {
  final _focusNode = FocusNode();
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final focused = _focusNode.hasFocus;
    final ringColor = widget.hasError
        ? AppColors.danger
        : focused
        ? AppColors.primary
        : AppColors.line;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textTheme.labelMedium!.copyWith(
            color: AppColors.inkSecondary,
          ),
        ),
        const SizedBox(height: 8),
        // Focus and error rings are shadows, not a thicker border, so the field
        // never changes size when its state changes.
        AnimatedContainer(
          duration: kStateDuration,
          height: kControlHeight,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(kRadiusControl),
            border: Border.all(color: ringColor),
            boxShadow: [
              if (focused && !widget.hasError)
                const BoxShadow(color: AppColors.primarySoft, spreadRadius: 4),
              if (focused || widget.hasError)
                BoxShadow(color: ringColor, spreadRadius: 0.5),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(widget.prefixIcon, size: 20, color: AppColors.inkTertiary),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  obscureText: widget.isPassword && _obscured,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  autocorrect: false,
                  enableSuggestions: !widget.isPassword,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.hintText,
                    hintStyle: textTheme.bodyLarge!.copyWith(
                      color: AppColors.inkTertiary,
                    ),
                  ),
                ),
              ),
              if (widget.isPassword)
                SizedBox(
                  width: kTapTarget,
                  height: kTapTarget,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _obscured = !_obscured),
                    child: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.inkTertiary,
                    ),
                  ),
                ),
              SizedBox(width: widget.isPassword ? 6 : 16),
            ],
          ),
        ),
      ],
    );
  }
}
