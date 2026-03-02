import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/auth_input_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../providers/auth_provider.dart';

class SignupCard extends ConsumerStatefulWidget {
  const SignupCard({super.key});

  @override
  ConsumerState<SignupCard> createState() => _SignupCardState();
}

class _SignupCardState extends ConsumerState<SignupCard> {
  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();

  bool _emailError = false;
  bool _isLoading  = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_emailController.text.endsWith('@lamduan.mfu.ac.th')) {
      setState(() => _emailError = true);
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }
    setState(() { _emailError = false; _isLoading = true; });
    try {
      await ref.read(authProvider.notifier).signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
        'Software Engineering', // default — updated in onboarding
        2,                      // default — updated in onboarding
      );
      if (mounted) context.go(RouteConstants.onboarding);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withValues(alpha: 0.08)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLogo(),
          const SizedBox(height: 12),
          const Text('Create Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Use your MFU Lamduan email',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
          const SizedBox(height: 24),
          AuthInputField(
            label: 'Full Name',
            hintText: 'e.g. Thaw Zin Myo Aung',
            prefixIcon: LucideIcons.user,
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'MFU Email',
            hintText: 'yourname@lamduan.mfu.ac.th',
            prefixIcon: LucideIcons.mail,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            hasError: _emailError,
            errorText: _emailError ? 'Must be an @lamduan.mfu.ac.th email address' : null,
          ),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'Password',
            hintText: 'Create a password',
            prefixIcon: LucideIcons.lock,
            showToggle: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'Confirm Password',
            hintText: 'Repeat your password',
            prefixIcon: LucideIcons.lock,
            showToggle: true,
            controller: _confirmController,
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Create Account', onPressed: _handleSignup, isLoading: _isLoading),
          const SizedBox(height: 16),
          const Text(
            'By signing up, you agree to our Terms & Privacy Policy',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account? ',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              TextButton(
                onPressed: () => context.go(RouteConstants.login),
                child: const Text('Log In',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

