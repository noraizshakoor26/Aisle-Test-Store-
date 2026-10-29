import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Discover', style: textTheme.displayMedium),
            const SizedBox(height: 8),
            Text(
              "You're signed in.",
              style: textTheme.bodyLarge!.copyWith(
                color: AppColors.inkSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
