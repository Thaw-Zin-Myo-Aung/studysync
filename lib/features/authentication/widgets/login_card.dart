import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studysync/core/constants/route_constants.dart';
import 'package:studysync/core/widgets/app_logo.dart';
import 'package:studysync/core/widgets/auth_input_field.dart';
import 'package:studysync/core/widgets/primary_button.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    context.go(RouteConstants.home);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLogo(),
          const SizedBox(height: 16),
          const Text(
            'StudySync',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          const Text(
            'Find your perfect study partner',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'Email',
            hintText: 'student_ID@lamduan.mfu.ac.th',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
          ),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'Password',
            hintText: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            showToggle: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Color(0xFF2563EB)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Log In', onPressed: _handleLogin),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('New to StudySync? ', style: TextStyle(fontSize: 14)),
              TextButton(
                onPressed: () => context.go(RouteConstants.home),
                child: const Text(
                  'Create Account',
                  style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

