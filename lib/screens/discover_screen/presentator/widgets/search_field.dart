import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.cancelAnimation,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.onCancel,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Animation<double> cancelAnimation;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: kControlHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(kRadiusControl),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(
                  Icons.search_rounded,
                  size: 22,
                  color: AppColors.inkSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    textInputAction: TextInputAction.search,
                    autocorrect: false,
                    style: textTheme.bodyLarge,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Search products, brands…',
                      hintStyle: textTheme.bodyLarge!.copyWith(
                        color: AppColors.inkTertiary,
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) => SizedBox(
                    width: kTapTarget,
                    height: kTapTarget,
                    child: value.text.isEmpty
                        ? null
                        : GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: onClear,
                            child: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: AppColors.inkTertiary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: cancelAnimation,
          axis: Axis.horizontal,
          alignment: Alignment.topLeft,
          child: FadeTransition(
            opacity: cancelAnimation,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onCancel,
              child: SizedBox(
                height: kControlHeight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: textTheme.labelLarge!.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
