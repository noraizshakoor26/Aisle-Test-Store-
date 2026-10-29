import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.line, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.copyWith(color: AppColors.inkTertiary),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.line, height: 1)),
      ],
    );
  }
}
