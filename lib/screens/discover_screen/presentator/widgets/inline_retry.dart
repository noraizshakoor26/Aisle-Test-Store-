import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';

class InlineRetry extends StatelessWidget {
  const InlineRetry({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: textTheme.labelMedium!.copyWith(color: AppColors.inkTertiary),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onRetry,
          child: SizedBox(
            height: kTapTarget,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  'Retry',
                  style: textTheme.labelMedium!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
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
