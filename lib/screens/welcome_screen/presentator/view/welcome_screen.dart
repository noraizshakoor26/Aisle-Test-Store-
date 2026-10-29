import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_store/core/services/navigator_service.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_primary_button.dart';
import 'package:test_store/core/widgets/aisle_wordmark.dart';
import 'package:test_store/screens/sign_in_screen/presentator/view/sign_in_screen.dart';
import 'package:test_store/screens/welcome_screen/presentator/widgets/showcase_wall.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final wallHeight = math.min(screenHeight * 0.58, screenHeight - 320);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: wallHeight, child: const ShowcaseWall()),
            Expanded(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(kGutter, 8, kGutter, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AisleWordmark(),
                      const SizedBox(height: 16),
                      Text(
                        'Everything you love,\none aisle away.',
                        style: textTheme.displayMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Curated products across beauty, home, fashion and tech.',
                        style: textTheme.bodyLarge!.copyWith(
                          color: AppColors.inkSecondary,
                        ),
                      ),
                      const Spacer(),
                      AislePrimaryButton(
                        label: 'Get started',
                        trailingIcon: Icons.arrow_forward_rounded,
                        onPressed: () =>
                            NavigatorService().push(const SignInScreen()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
