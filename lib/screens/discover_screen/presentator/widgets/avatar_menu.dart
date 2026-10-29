import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/widgets/aisle_network_image.dart';

class AvatarMenu extends StatelessWidget {
  const AvatarMenu({
    super.key,
    required this.imageUrl,
    required this.onSignOut,
  });

  final String imageUrl;
  final VoidCallback onSignOut;

  static const double _size = 44;

  Widget _avatar(MenuController controller) {
    return GestureDetector(
      onTap: () => controller.isOpen ? controller.close() : controller.open(),
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          border: Border.all(color: AppColors.butter, width: 2),
        ),
        child: ClipOval(
          child: imageUrl.isEmpty
              ? const Icon(Icons.person_rounded, color: AppColors.butter)
              : AisleNetworkImage(
                  url: imageUrl,
                  fit: BoxFit.cover,
                  radius: _size / 2,
                  cacheWidth: 132,
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
        builder: (context, controller, child) => _avatar(controller),
      );
    }
    return MenuAnchor(
      alignmentOffset: const Offset(-96, 8),
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.logout_rounded, color: AppColors.danger),
          onPressed: onSignOut,
          child: Text(
            'Sign out',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: AppColors.danger,
            ),
          ),
        ),
      ],
      builder: (context, controller, child) => _avatar(controller),
    );
  }
}
