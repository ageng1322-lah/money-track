// lib/features/profile/presentation/detail_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

class DetailProfileScreen extends ConsumerStatefulWidget {
  const DetailProfileScreen({super.key});

  @override
  ConsumerState<DetailProfileScreen> createState() => _DetailProfileScreenState();
}

class _DetailProfileScreenState extends ConsumerState<DetailProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).valueOrNull;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showMsg(String title, String msg, {bool isError = false}) {
    Get.snackbar(
      title, 
      msg,
      backgroundColor: isError ? AppTheme.expense : AppTheme.primary,
      colorText: isError ? Colors.white : (Get.isDarkMode ? Colors.black : Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    
    if (image != null) {
      setState(() => _isSaving = true);
      try {
        final repo = ref.read(profileRepositoryProvider);
        await repo.updatePhoto(image.path);
        
        ref.invalidate(authProvider);
        _showMsg('SUCCESS', 'Profile photo updated successfully');
      } catch (e) {
        String errorMsg = 'Failed to upload photo';
        if (e is DioException) {
          errorMsg = e.response?.data['message'] ?? errorMsg;
        }
        _showMsg('ERROR', errorMsg, isError: true);
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deletePhoto() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('DELETE PHOTO?', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w900)),
        content: const Text('Are you sure you want to remove your profile photo?', style: TextStyle(color: AppTheme.textDim)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('CANCEL', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.expense, minimumSize: const Size(100, 40)),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isSaving = true);
      try {
        final repo = ref.read(profileRepositoryProvider);
        await repo.deletePhoto();
        ref.invalidate(authProvider);
        _showMsg('SUCCESS', 'Profile photo removed');
      } catch (e) {
        _showMsg('ERROR', 'Failed to remove photo', isError: true);
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(profileRepositoryProvider);
      await repo.updateProfile(
        name:  _nameController.text,
        email: _emailController.text,
      );
      ref.invalidate(authProvider);
      _showMsg('SUCCESS', 'Profile updated successfully');
    } catch (e) {
      String errorMsg = 'Failed to update profile';
      if (e is DioException) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
      }
      _showMsg('ERROR', errorMsg, isError: true);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    String initial = '?';
    if (user != null && user.name.isNotEmpty) {
      initial = user.name[0].toUpperCase();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Text('Edit Profile', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Avatar Section
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 100),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.primary, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primary.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: colorScheme.surfaceVariant,
                                  backgroundImage: (user?.photoUrl != null && user!.photoUrl!.isNotEmpty) ? NetworkImage(user!.photoUrl!) : null,
                                  child: (user?.photoUrl == null || user!.photoUrl!.isEmpty)
                                      ? Text(initial, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppTheme.primary))
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: AppTheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.camera_alt, color: isDark ? Colors.black : Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _pickImage,
                          child: const Text(
                            'UPDATE AVATAR',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),

                  // Form Fields
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FULL NAME', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 12),
                        _buildTextField(
                          context: context,
                          controller: _nameController,
                          icon: Icons.person_outline,
                          hint: 'Alexander Vance',
                          validator: (v) => v!.isEmpty ? 'Name cannot be empty' : null,
                        ),
                        const SizedBox(height: 24),
                        Text('EMAIL ADDRESS', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 12),
                        _buildTextField(
                          context: context,
                          controller: _emailController,
                          icon: Icons.mail_outline,
                          hint: 'alex.vance@neotrack.io',
                          validator: (v) => v!.isEmpty ? 'Email cannot be empty' : null,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60),

                  // Action Buttons
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: isDark ? Colors.black : Colors.white,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: isDark ? 10 : 2,
                            shadowColor: AppTheme.primary.withOpacity(0.3),
                          ),
                          child: _isSaving 
                            ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3, color: isDark ? Colors.black : Colors.white))
                            : const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 32),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Text(
                            'CANCEL UPDATE',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (_isSaving)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
        gradient: RadialGradient(
          colors: [AppTheme.primary.withOpacity(0.08), Colors.transparent],
          center: const Alignment(1.5, -1.5),
          radius: 2.2,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withOpacity(0.12)),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          filled: false,
          hintText: hint,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }
}
