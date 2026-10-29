import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_store/core/enums/status_indicator.dart';
import 'package:test_store/core/theme/app_colors.dart';
import 'package:test_store/core/utils/constants.dart';
import 'package:test_store/core/widgets/aisle_primary_button.dart';
import 'package:test_store/core/widgets/aisle_text_field.dart';
import 'package:test_store/core/widgets/aisle_wordmark.dart';
import 'package:test_store/screens/sign_in_screen/presentator/bloc/sign_in_bloc.dart';
import 'package:test_store/screens/sign_in_screen/presentator/widgets/avatar_cluster.dart';
import 'package:test_store/screens/sign_in_screen/presentator/widgets/google_logo.dart';
import 'package:test_store/screens/sign_in_screen/presentator/widgets/or_divider.dart';
import 'package:test_store/screens/sign_in_screen/presentator/widgets/social_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _canSubmit =>
      _usernameController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    context.read<SignInBloc>().add(SignInErrorCleared());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFieldChanged(String _) {
    setState(() {});
    context.read<SignInBloc>().add(SignInErrorCleared());
  }

  void _submit() {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    context.read<SignInBloc>().add(
      SignInRequested(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _showComingSoon(String provider) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$provider sign-in is coming soon.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: kScreenPadding,
                sliver: SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AisleWordmark(fontSize: 22),
                          AvatarCluster(),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text('Welcome back', style: textTheme.displayMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to explore the collection.',
                        style: textTheme.bodyLarge!.copyWith(
                          color: AppColors.inkSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<SignInBloc, SignInState>(
                        builder: (context, state) {
                          final isLoading =
                              state.status == StatusIndicator.loading;
                          final errorMessage = state.errorMessage;
                          return Column(
                            children: [
                              AisleTextField(
                                label: 'Username',
                                hintText: 'Enter your username',
                                controller: _usernameController,
                                prefixIcon: Icons.person_outline_rounded,
                                hasError: errorMessage != null,
                                enabled: !isLoading,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.username],
                                onChanged: _onFieldChanged,
                              ),
                              const SizedBox(height: 16),
                              AisleTextField(
                                label: 'Password',
                                hintText: 'Enter your password',
                                controller: _passwordController,
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                hasError: errorMessage != null,
                                enabled: !isLoading,
                                textInputAction: TextInputAction.go,
                                autofillHints: const [AutofillHints.password],
                                onChanged: _onFieldChanged,
                                onSubmitted: (_) => _submit(),
                              ),
                              SizedBox(
                                height: 36,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AnimatedSwitcher(
                                    duration: kStateDuration,
                                    child: errorMessage == null
                                        ? const SizedBox.shrink()
                                        : Row(
                                            key: ValueKey(errorMessage),
                                            children: [
                                              const Icon(
                                                Icons.error_outline_rounded,
                                                size: 16,
                                                color: AppColors.danger,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  errorMessage,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: textTheme.labelMedium!
                                                      .copyWith(
                                                        color: AppColors.danger,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                              AislePrimaryButton(
                                label: 'Sign in',
                                isLoading: isLoading,
                                onPressed: _canSubmit ? _submit : null,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const OrDivider(label: 'or continue with'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SocialButton(
                              label: 'Apple',
                              logo: const Icon(
                                Icons.apple,
                                size: 22,
                                color: AppColors.ink,
                              ),
                              onPressed: () => _showComingSoon('Apple'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SocialButton(
                              label: 'Google',
                              logo: const GoogleLogo(),
                              onPressed: () => _showComingSoon('Google'),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.shield_outlined,
                              size: 14,
                              color: AppColors.inkTertiary,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Your session is encrypted and stored on this device.',
                                textAlign: TextAlign.center,
                                style: textTheme.labelMedium!.copyWith(
                                  color: AppColors.inkTertiary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
