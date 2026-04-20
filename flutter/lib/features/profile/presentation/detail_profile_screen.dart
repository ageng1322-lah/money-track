// lib/features/profile/presentation/detail_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';

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
      colorText: isError ? Colors.white : Colors.black,
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
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('DELETE PHOTO?', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w900)),
        content: const Text('Are you sure you want to remove your profile photo?', style: TextStyle(color: AppTheme.textDim)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL', style: TextStyle(color: AppTheme.textDim))),
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
    
    String initial = '?';
    if (user != null && user.name.isNotEmpty) {
      initial = user.name[0].toUpperCase();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PERSONAL INFO'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primary.withOpacity(0.5), width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: AppTheme.surface,
                            backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                            child: user?.photoUrl == null
                                ? Text(initial, 
                                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppTheme.primary, fontStyle: FontStyle.italic))
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.background, width: 4),
                                boxShadow: [
                                  BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
                                ],
                              ),
                              child: const Icon(Icons.camera_alt_rounded, color: Colors.black, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (user?.photoUrl != null)
                    TextButton.icon(
                      onPressed: _deletePhoto,
                      icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppTheme.expense),
                      label: const Text('REMOVE PHOTO', 
                        style: TextStyle(color: AppTheme.expense, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                    ),
                  
                  const SizedBox(height: 48),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('FULL NAME', style: TextStyle(color: AppTheme.textDim, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                          prefixIcon: Icon(Icons.person_outline_rounded, color: AppTheme.textDim),
                        ),
                        validator: (v) => v!.isEmpty ? 'Name cannot be empty' : null,
                      ),
                      const SizedBox(height: 24),
                      const Text('EMAIL ADDRESS', style: TextStyle(color: AppTheme.textDim, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email_outlined, color: AppTheme.textDim),
                        ),
                        validator: (v) => v!.isEmpty ? 'Email cannot be empty' : null,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 60),

                  ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black))
                      : const Text('SAVE CHANGES'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                    child: const Text('DISCARD', style: TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold)),
                  ),
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
}
