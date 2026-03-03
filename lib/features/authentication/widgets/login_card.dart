import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:studysync/core/constants/route_constants.dart';
import 'package:studysync/core/theme/app_colors.dart';
import 'package:studysync/core/widgets/app_logo.dart';
import 'package:studysync/core/widgets/auth_input_field.dart';
import 'package:studysync/core/widgets/primary_button.dart';
import '../../../providers/auth_provider.dart';
class LoginCard extends ConsumerStatefulWidget {
  const LoginCard({super.key});
  @override
  ConsumerState<LoginCard> createState() => _LoginCardState();
}
class _LoginCardState extends ConsumerState<LoginCard> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) context.go(RouteConstants.home);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  Future<void> _handleForgotPassword() async {
    final resetEmailCtrl = TextEditingController(
      text: _emailController.text.trim(),
    );
    await showDialog(
      context: context,
      builder: (ctx) {
        bool sending = false;
        bool sent    = false;
        String? error;
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: const Text('Reset Password',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!sent) ...[
                  const Text(
                    "Enter your MFU email and we'll send a password reset link.",
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: resetEmailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'student_ID@lamduan.mfu.ac.th',
                      hintStyle: const TextStyle(fontSize: 13),
                      prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(LucideIcons.mail, color: Colors.grey, size: 18),
                      ),
                      filled: true,
                      fillColor: AppColors.primarySurface,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                      isDense: true,
                      errorText: error,
                    ),
                    onChanged: (_) => setDialogState(() => error = null),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                        child: const Icon(LucideIcons.mail, color: AppColors.success, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('Reset link sent! Check your inbox.',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.success)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: sent
                ? [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Done', style: TextStyle(color: Colors.white)),
                    ),
                  ]
                : [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    ElevatedButton(
                      onPressed: sending
                          ? null
                          : () async {
                              final email = resetEmailCtrl.text.trim();
                              if (email.isEmpty) {
                                setDialogState(() => error = 'Please enter your email.');
                                return;
                              }
                              setDialogState(() => sending = true);
                              try {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                                setDialogState(() { sending = false; sent = true; });
                              } on FirebaseAuthException catch (e) {
                                setDialogState(() { sending = false; error = e.message ?? 'Failed to send reset email.'; });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: sending
                          ? const SizedBox(width: 18, height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Send Link', style: TextStyle(color: Colors.white)),
                    ),
                  ],
          ),
        );
      },
    );
    resetEmailCtrl.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withValues(alpha: 0.08))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLogo(),
          const SizedBox(height: 16),
          const Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Study', style: TextStyle(color: Colors.black87)),
                TextSpan(text: 'Sync', style: TextStyle(color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Find your perfect study partner',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'Email',
            hintText: 'student_ID@lamduan.mfu.ac.th',
            prefixIcon: LucideIcons.mail,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
          ),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'Password',
            hintText: 'Password',
            prefixIcon: LucideIcons.lock,
            obscureText: true,
            showToggle: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: const Text('Forgot Password?',
                  style: TextStyle(color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 8),
          PrimaryButton(label: 'Log In', onPressed: _handleLogin, isLoading: _isLoading),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(
                child: Text('New to StudySync? ',
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis),
              ),
              TextButton(
                onPressed: () => context.go(RouteConstants.signup),
                child: const Text('Create Account',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
