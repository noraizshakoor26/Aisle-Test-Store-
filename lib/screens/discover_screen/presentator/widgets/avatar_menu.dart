import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';

class AvatarMenu extends StatelessWidget {
  const AvatarMenu({
    super.key,
    required this.initials,
    required this.onSignOut,
  });

  final String initials;
  final VoidCallback onSignOut;

  static const double _size = 44;

  Widget _avatar(BuildContext context, MenuController controller) {
    return GestureDetector(
      onTap: () => controller.isOpen ? controller.close() : controller.open(),
      child: Container(
        width: _size,
        height: _size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.butter,
          border: Border.all(
            color: AppColors.onPrimary.withValues(alpha: 0.25),
            width: 2,
          ),
        ),
        child: initials.isEmpty
            ? const Icon(Icons.person_rounded, color: AppColors.primaryDeep)
            : Text(
                initials,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                  color: AppColors.primaryDeep,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoMenuAnchor(
        menuChildren: [
          CupertinoMenuItem(
            isDestructiveAction: true,
            trailing: const Icon(CupertinoIcons.square_arrow_right),
            onPressed: onSignOut,
            child: const Text('Sign out'),
          ),
        ],
        builder: (context, controller, child) => _avatar(context, controller),
      );
    }
    return MenuAnchor(
      alignmentOffset: const Offset(-96, 8),
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(
            Icons.logout_rounded,
            color: AppColors.danger,
          ),
          onPressed: onSignOut,
          child: Text(
            'Sign out',
            style: Theme.of(
              context,
            ).textTheme.labelLarge!.copyWith(color: AppColors.danger),
          ),
        ),
      ],
      builder: (context, controller, child) => _avatar(context, controller),
    );
  }
}
