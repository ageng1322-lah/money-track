// lib/features/category/presentation/category_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  final String? initialType;
  const CategoryFormScreen({super.key, this.initialType});

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _iconCtrl = TextEditingController(text: '📁');
  final _colorCtrl = TextEditingController(text: '#10B981');

  String _type = 'expense';
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      _type = widget.initialType!;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _iconCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final repo = ref.read(categoryRepositoryProvider);
      await repo.createCategory(
        name: _nameCtrl.text.trim(),
        icon: _iconCtrl.text.trim(),
        type: _type,
        color: _colorCtrl.text.trim(),
      );

      // Invalidate categories list
      ref.invalidate(categoriesProvider);

      if (mounted) {
        getx.Get.back();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : colorScheme.background,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100, right: -50,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppTheme.primary.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New Category',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => getx.Get.back(),
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppTheme.expense.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.expense.withOpacity(0.3)),
                        ),
                        child: Text(_error!, style: const TextStyle(color: AppTheme.expense, fontSize: 13)),
                      ),
                    ],

                    // Name
                    _buildLabel('NAMA KATEGORI'),
                    _buildTextField(
                      controller: _nameCtrl,
                      hint: 'Misal: Makan Siang, Transport, dll',
                      validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 32),

                    // Icon and Color Row
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('ICON (EMOJI)'),
                              _buildTextField(
                                controller: _iconCtrl,
                                hint: '📁',
                                textAlign: TextAlign.center,
                                validator: (v) => (v == null || v.isEmpty) ? 'Wajib' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('WARNA'),
                              _buildColorPicker(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Type
                    _buildLabel('TIPE'),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _TypeBtn(
                              label: 'EXPENSE',
                              isActive: _type == 'expense',
                              onTap: () => setState(() => _type = 'expense'),
                              color: AppTheme.expense,
                            ),
                          ),
                          Expanded(
                            child: _TypeBtn(
                              label: 'INCOME',
                              isActive: _type == 'income',
                              onTap: () => setState(() => _type = 'income'),
                              color: AppTheme.income,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Footer Buttons (Stacked)
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 8,
                              shadowColor: AppTheme.primary.withOpacity(0.4),
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(color: Colors.black)
                                : Text(
                                    'SIMPAN KATEGORI',
                                    style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: TextButton(
                            onPressed: () => getx.Get.back(),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.05),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              'BATAL',
                              style: GoogleFonts.spaceGrotesk(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          color: Colors.white.withOpacity(0.4),
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextAlign textAlign = TextAlign.start,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: textAlign,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.1)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      validator: validator,
    );
  }



  Widget _buildColorPicker() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 24, height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _colorCtrl.text,
              style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color color;

  const _TypeBtn({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive ? [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 15, spreadRadius: 1)
          ] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: isActive ? Colors.black : Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
