import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/groups_provider.dart';
import '../widgets/create_group_form.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _formKey         = GlobalKey<FormState>();
  final _nameCtrl        = TextEditingController();
  final _courseCtrl      = TextEditingController();
  final _locationCtrl    = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  int  _maxMembers       = 6;
  bool _isLoading        = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _courseCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(groupsProvider.notifier).createGroup(
        name:        _nameCtrl.text.trim(),
        course:      _courseCtrl.text.trim(),
        location:    _locationCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        maxMembers:  _maxMembers,
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create group: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black12,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
        title: const Text('Create Study Group',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ── Background blobs ─────────────────────────────────
          Positioned(
            top: -20, right: -40,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.22),
                  AppColors.primary.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          Positioned(
            top: 30, left: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF60A5FA).withValues(alpha: 0.18),
                  const Color(0xFF60A5FA).withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: 80, right: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFBAD7FF).withValues(alpha: 0.28),
                  const Color(0xFFBAD7FF).withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),

          // ── Scrollable form ───────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  CreateGroupForm(
                    formKey:               _formKey,
                    nameController:        _nameCtrl,
                    courseController:      _courseCtrl,
                    locationController:    _locationCtrl,
                    descriptionController: _descriptionCtrl,
                    maxMembers:            _maxMembers,
                    onMaxMembersChanged:   (v) =>
                        setState(() => _maxMembers = v),
                  ),
                  const SizedBox(height: 28),

                  // ── Create Group button ───────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22, height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white))
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.users,
                                    size: 18, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Create Group',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

