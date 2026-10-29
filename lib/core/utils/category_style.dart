import 'package:flutter/material.dart';
import 'package:test_store/core/theme/app_colors.dart';

class CategoryStyle {
  static const Map<String, Color> _tints = {
    'groceries': AppColors.tintMint,
    'kitchen-accessories': AppColors.tintMint,
    'home-decoration': AppColors.tintMint,
    'sports-accessories': AppColors.tintMint,
    'beauty': AppColors.tintBlush,
    'skin-care': AppColors.tintBlush,
    'womens-dresses': AppColors.tintBlush,
    'womens-bags': AppColors.tintBlush,
    'womens-jewellery': AppColors.tintBlush,
    'furniture': AppColors.tintSand,
    'mens-shirts': AppColors.tintSand,
    'mens-shoes': AppColors.tintSand,
    'womens-shoes': AppColors.tintSand,
    'sunglasses': AppColors.tintSand,
    'fragrances': AppColors.tintButter,
    'mens-watches': AppColors.tintButter,
    'womens-watches': AppColors.tintButter,
    'tops': AppColors.tintButter,
    'laptops': AppColors.tintSage,
    'smartphones': AppColors.tintSage,
    'tablets': AppColors.tintSage,
    'mobile-accessories': AppColors.tintSage,
    'motorcycle': AppColors.tintSage,
    'vehicle': AppColors.tintSage,
  };

  static const Map<String, IconData> _icons = {
    'beauty': Icons.brush_outlined,
    'fragrances': Icons.spa_outlined,
    'furniture': Icons.chair_outlined,
    'groceries': Icons.local_grocery_store_outlined,
    'home-decoration': Icons.cottage_outlined,
    'kitchen-accessories': Icons.kitchen_outlined,
    'laptops': Icons.laptop_mac_outlined,
    'mens-shirts': Icons.checkroom_outlined,
    'mens-shoes': Icons.directions_walk_rounded,
    'mens-watches': Icons.watch_outlined,
    'mobile-accessories': Icons.headphones_outlined,
    'motorcycle': Icons.two_wheeler_outlined,
    'skin-care': Icons.water_drop_outlined,
    'smartphones': Icons.smartphone_outlined,
    'sports-accessories': Icons.sports_basketball_outlined,
    'sunglasses': Icons.wb_sunny_outlined,
    'tablets': Icons.tablet_mac_outlined,
    'tops': Icons.dry_cleaning_outlined,
    'vehicle': Icons.directions_car_outlined,
    'womens-bags': Icons.shopping_bag_outlined,
    'womens-dresses': Icons.woman_outlined,
    'womens-jewellery': Icons.diamond_outlined,
    'womens-shoes': Icons.roller_skating_outlined,
    'womens-watches': Icons.watch_outlined,
  };

  static Color tintFor(String slug) => _tints[slug] ?? AppColors.tintSand;

  static IconData iconFor(String slug) =>
      _icons[slug] ?? Icons.category_outlined;
}
