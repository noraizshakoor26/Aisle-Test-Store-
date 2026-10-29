import 'package:flutter/material.dart';
import 'package:test_store/core/enums/status_indicator.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/screens/discover_screen/presentator/widgets/inline_retry.dart';

class ListFooter extends StatelessWidget {
  const ListFooter({
    super.key,
    required this.pageStatus,
    required this.hasReachedEnd,
    required this.total,
    required this.onRetry,
  });

  final StatusIndicator pageStatus;
  final bool hasReachedEnd;
  final int total;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (pageStatus == StatusIndicator.failed) {
      child = InlineRetry(
        key: const ValueKey('failed'),
        message: "Couldn't load more",
        onRetry: onRetry,
      );
    } else if (hasReachedEnd) {
      child = Text(
        "You've reached the end · $total products",
        key: const ValueKey('end'),
        style: Theme.of(
          context,
        ).textTheme.labelMedium!.copyWith(color: AppColors.inkTertiary),
      );
    } else {
      child = const SizedBox(
        key: ValueKey('loading'),
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return SizedBox(
      height: 72,
      child: Center(
        child: AnimatedSwitcher(duration: kStateDuration, child: child),
      ),
    );
  }
}
