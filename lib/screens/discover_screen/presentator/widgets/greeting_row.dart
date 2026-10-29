import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/avatar_menu.dart';

class GreetingRow extends StatelessWidget {
  const GreetingRow({
    super.key,
    required this.greeting,
    required this.name,
    required this.initials,
    required this.onSignOut,
  });

  final String greeting;
  final String name;
  final String initials;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                greeting,
                style: textTheme.bodyMedium!.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.75),
                ),
              ),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.displayMedium!.copyWith(
                  fontSize: 22,
                  height: 28 / 22,
                  letterSpacing: -0.5,
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
        ),
        AvatarMenu(initials: initials, onSignOut: onSignOut),
      ],
    );
  }
}
