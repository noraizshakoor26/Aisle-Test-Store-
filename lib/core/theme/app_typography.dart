import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_store/core/theme/app_colors.dart';

class AppTypography {
  static TextStyle get _heading =>
      GoogleFonts.plusJakartaSans(color: AppColors.ink);

  static TextStyle get _body => GoogleFonts.inter(color: AppColors.ink);

  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: _heading.copyWith(
        fontSize: 48,
        height: 52 / 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        fontFeatures: _tabular,
      ),
      displayMedium: _heading.copyWith(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      displaySmall: _heading.copyWith(
        fontSize: 30,
        height: 36 / 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      headlineLarge: _heading.copyWith(
        fontSize: 30,
        height: 36 / 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        fontFeatures: _tabular,
      ),
      headlineMedium: _heading.copyWith(
        fontSize: 26,
        height: 32 / 26,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
      ),
      headlineSmall: _heading.copyWith(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: _heading.copyWith(
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleMedium: _heading.copyWith(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        fontFeatures: _tabular,
      ),
      titleSmall: _body.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: _body.copyWith(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
      ),
      bodyMedium: _body.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: _body.copyWith(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        color: AppColors.inkSecondary,
        fontFeatures: _tabular,
      ),
      labelLarge: _body.copyWith(
        fontSize: 15,
        height: 20 / 15,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: _body.copyWith(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: _body.copyWith(
        fontSize: 11,
        height: 16 / 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColors.inkTertiary,
      ),
    );
  }
}
