import 'package:flutter/gestures.dart';
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

  bool _isLoading = false;
  bool _agreedToTerms = false;

  // ── Live validation state ────────────────────────────────────────────────
  bool _emailTouched    = false;
  bool _passTouched     = false;
  bool _confirmTouched  = false;

  static bool _hasMinLength(String p) => p.length >= 6;
  static bool _hasUppercase(String p) => p.contains(RegExp(r'[A-Z]'));
  static bool _hasSymbol(String p)    => p.contains(RegExp(r'[^a-zA-Z0-9]'));

  String? get _emailError {
    if (!_emailTouched) return null;
    final e = _emailController.text.trim();
    if (e.isEmpty) return 'Email is required';
    if (!e.endsWith('@lamduan.mfu.ac.th')) return 'Must be a @lamduan.mfu.ac.th email';
    return null;
  }

  String? get _passwordError {
    if (!_passTouched) return null;
    final p = _passwordController.text;
    if (p.isEmpty) return 'Password is required';
    final missing = <String>[];
    if (!_hasMinLength(p)) missing.add('6+ characters');
    if (!_hasUppercase(p)) missing.add('1 uppercase letter');
    if (!_hasSymbol(p))    missing.add('1 symbol');
    if (missing.isEmpty) return null;
    return 'Needs: ${missing.join(' · ')}';
  }

  String? get _confirmError {
    if (!_confirmTouched) return null;
    if (_confirmController.text.isEmpty) return 'Please confirm your password';
    if (_confirmController.text != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(()   => setState(() => _emailTouched   = true));
    _passwordController.addListener(() => setState(() {
      _passTouched    = true;
      // Re-validate confirm when password changes
      if (_confirmTouched) setState(() {});
    }));
    _confirmController.addListener(()  => setState(() => _confirmTouched = true));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    // Force-touch all fields so errors show on submit
    setState(() {
      _emailTouched   = true;
      _passTouched    = true;
      _confirmTouched = true;
    });

    if (_emailError != null || _passwordError != null || _confirmError != null) return;
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
        'Software Engineering',
        2,
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
    final pass = _passwordController.text;

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
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Use your MFU Lamduan email',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
          const SizedBox(height: 24),

          // ── Full Name ──────────────────────────────────────────────────
          AuthInputField(
            label: 'Full Name',
            hintText: 'e.g. Your Full Name',
            prefixIcon: LucideIcons.user,
            controller: _nameController,
          ),
          const SizedBox(height: 16),

          // ── MFU Email (live) ───────────────────────────────────────────
          AuthInputField(
            label: 'MFU Email',
            hintText: 'student_ID@lamduan.mfu.ac.th',
            prefixIcon: LucideIcons.mail,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            hasError: _emailError != null,
            errorText: _emailError,
          ),
          const SizedBox(height: 16),

          // ── Password (live) ────────────────────────────────────────────
          AuthInputField(
            label: 'Password',
            hintText: 'Create a password',
            prefixIcon: LucideIcons.lock,
            showToggle: true,
            controller: _passwordController,
            hasError: _passwordError != null,
            errorText: _passwordError,
          ),

          // Password strength checklist (shown once user starts typing)
          if (_passTouched && pass.isNotEmpty) ...[
            const SizedBox(height: 10),
            _PasswordRuleRow(label: '6+ characters',      met: _hasMinLength(pass)),
            const SizedBox(height: 4),
            _PasswordRuleRow(label: '1 uppercase letter', met: _hasUppercase(pass)),
            const SizedBox(height: 4),
            _PasswordRuleRow(label: '1 symbol (!@#\$…)',   met: _hasSymbol(pass)),
          ],

          const SizedBox(height: 16),

          // ── Confirm Password (live) ────────────────────────────────────
          AuthInputField(
            label: 'Confirm Password',
            hintText: 'Repeat your password',
            prefixIcon: LucideIcons.lock,
            showToggle: true,
            controller: _confirmController,
            hasError: _confirmError != null,
            errorText: _confirmError,
          ),

          // Match indicator
          if (_confirmTouched && _confirmController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _confirmError == null
                      ? LucideIcons.circleCheck
                      : LucideIcons.circleX,
                  size: 13,
                  color: _confirmError == null
                      ? AppColors.success
                      : AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  _confirmError == null
                      ? 'Passwords match'
                      : 'Passwords do not match',
                  style: TextStyle(
                    fontSize: 12,
                    color: _confirmError == null
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),
          Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Checkbox(
                 value: _agreedToTerms,
                 activeColor: AppColors.primary,
                 onChanged: (value) =>
                     setState(() => _agreedToTerms = value ?? false),
               ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.only(top: 10),
                   child: RichText(
                     text: TextSpan(
                       style: const TextStyle(
                         fontSize: 12,
                         color: AppColors.textSecondary,
                         height: 1.4,
                       ),
                       children: [
                         const TextSpan(text: 'I agree to the '),
                         TextSpan(
                           text: 'Terms & Conditions',
                           style: const TextStyle(color: AppColors.primary),
                           recognizer: TapGestureRecognizer()
                             ..onTap = () =>
                                 context.push(RouteConstants.termsConditions),
                         ),
                         const TextSpan(text: ' and '),
                         TextSpan(
                           text: 'Privacy Policy',
                           style: const TextStyle(color: AppColors.primary),
                           recognizer: TapGestureRecognizer()
                             ..onTap = () =>
                                 context.push(RouteConstants.privacyPolicy),
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
             ],
           ),
           const SizedBox(height: 16),
           PrimaryButton(
               label: 'Create Account',
               onPressed: _agreedToTerms ? () => _handleSignup() : null,
               isLoading: _isLoading),
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
              const Flexible(
                child: Text('Already have an account? ',
                    style: TextStyle(
                        fontSize: 14, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis),
              ),
              TextButton(
                onPressed: () => context.go(RouteConstants.login),
                child: const Text('Log In',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Small rule row widget ────────────────────────────────────────────────────
class _PasswordRuleRow extends StatelessWidget {
  final String label;
  final bool met;
  const _PasswordRuleRow({required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          met ? LucideIcons.circleCheck : LucideIcons.circle,
          size: 13,
          color: met ? AppColors.success : AppColors.textHint,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: met ? AppColors.success : AppColors.textHint,
          ),
        ),
      ],
    );
  }
}
