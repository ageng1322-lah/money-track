// lib/features/transaction/presentation/transaction_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  final int? transactionId;
  const TransactionFormScreen({super.key, this.transactionId});

  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String _type = 'expense';
  DateTime _date = DateTime.now();
  int? _categoryId;
  bool _loading = false;
  String? _error;

  bool get isEdit => widget.transactionId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadTransaction());
    }
  }

  Future<void> _loadTransaction() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(transactionRepositoryProvider);
      final tx = await repo.getTransactionById(widget.transactionId!);

      setState(() {
        _titleCtrl.text = tx.title;
        _amountCtrl.text = tx.amount.toInt().toString();
        _noteCtrl.text = tx.note ?? '';
        _type = tx.type;
        _date = tx.date;
        _categoryId = tx.category?.id;
      });
    } catch (e) {
      setState(() => _error = "Gagal memuat data: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_categoryId == null) {
      setState(() => _error = 'Pilih kategori terlebih dahulu');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final repo = ref.read(transactionRepositoryProvider);
      final amount = double.parse(_amountCtrl.text.replaceAll(',', ''));

      if (isEdit) {
        await repo.updateTransaction(widget.transactionId!, {
          'title': _titleCtrl.text.trim(),
          'amount': amount,
          'type': _type,
          'date': DateFormatter.toApiDate(_date),
          'category_id': _categoryId,
          'note': _noteCtrl.text.isEmpty ? null : _noteCtrl.text.trim(),
        });
      } else {
        await repo.createTransaction(
          title: _titleCtrl.text.trim(),
          amount: amount,
          type: _type,
          date: DateFormatter.toApiDate(_date),
          categoryId: _categoryId,
          note: _noteCtrl.text.isEmpty ? null : _noteCtrl.text.trim(),
        );
      }

      // Immediate UI update
      ref.invalidate(transactionListProvider);
      ref.read(dashboardProvider.notifier).refresh();

      if (mounted) {
        if (isEdit) {
          getx.Get.back();
        } else {
          // Get category info for success screen
          final categories = ref.read(categoriesProvider).valueOrNull ?? [];
          final selectedCat = categories.firstWhere(
            (c) => c.id == _categoryId,
            orElse: () => categories.isNotEmpty ? categories.first : throw 'Category not found',
          );

          getx.Get.offNamed('/transactions/success', arguments: {
            'amount': amount,
            'categoryName': selectedCat.name,
            'categoryIcon': selectedCat.icon,
            'type': _type,
          });
        }
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => getx.Get.back(),
        ),
        title: Text(
          isEdit ? 'Edit Transaction' : 'Add Transaction',
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: _loading && isEdit
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppTheme.expense.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.expense.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: AppTheme.expense, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _error!,
                                style: const TextStyle(color: AppTheme.expense, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Type Toggle (Expense/Income)
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 100),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _TypeToggleBtn(
                                label: 'EXPENSE',
                                isActive: _type == 'expense',
                                activeColor: AppTheme.expense,
                                onTap: () => setState(() {
                                  _type = 'expense';
                                  _categoryId = null;
                                }),
                              ),
                              _TypeToggleBtn(
                                label: 'INCOME',
                                isActive: _type == 'income',
                                activeColor: AppTheme.income,
                                onTap: () => setState(() {
                                  _type = 'income';
                                  _categoryId = null;
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Amount Card
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 200),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'AMOUNT',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Rp',
                                  style: TextStyle(
                                    color: _type == 'expense' ? AppTheme.expense : AppTheme.income,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IntrinsicWidth(
                                  child: TextFormField(
                                    controller: _amountCtrl,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _type == 'expense' ? AppTheme.expense : AppTheme.income,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Outfit',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                      hintStyle: TextStyle(color: (_type == 'expense' ? AppTheme.expense : AppTheme.income).withOpacity(0.3)),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      fillColor: Colors.transparent,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      _ThousandsSeparatorFormatter(),
                                    ],
                                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title Field
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
                            ),
                            child: TextFormField(
                              controller: _titleCtrl,
                              style: TextStyle(color: colorScheme.onSurface, fontSize: 15),
                              decoration: InputDecoration(
                                hintText: 'What is this for?',
                                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 15),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Colors.transparent,
                                prefixIcon: Icon(Icons.edit_note, color: colorScheme.onSurfaceVariant, size: 24),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Category Section
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          categoriesAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
                            error: (err, _) => const Text('Error loading categories'),
                            data: (categories) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.85,
                                ),
                                itemCount: categories.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == categories.length) {
                                    return _AddCategoryBtn(
                                      onTap: () => getx.Get.toNamed(
                                        '/categories/add',
                                        parameters: {'type': _type},
                                      ),
                                    );
                                  }
                                  final cat = categories[index];
                                  final isSelected = _categoryId == cat.id;
                                  return _CategoryBtn(
                                    icon: cat.icon,
                                    label: cat.name,
                                    isSelected: isSelected,
                                    onTap: () => setState(() => _categoryId = cat.id),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Details Section
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _DetailsCard(
                            icon: Icons.calendar_today_outlined,
                            label: 'Date',
                            value: DateFormat('EEEE, MMM dd yyyy').format(_date),
                            onTap: _pickDate,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Icon(Icons.notes, color: colorScheme.onSurfaceVariant, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Note (Optional)',
                                        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        controller: _noteCtrl,
                                        maxLines: null,
                                        minLines: 3,
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(color: colorScheme.onSurface, fontSize: 15, height: 1.4),
                                        decoration: InputDecoration(
                                          hintText: 'Add extra details...',
                                          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.5), fontSize: 15),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          fillColor: Colors.transparent,
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Submit Button
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 600),
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          minimumSize: const Size(double.infinity, 64),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                          elevation: isDark ? 10 : 2,
                          shadowColor: AppTheme.primary.withOpacity(0.3),
                        ),
                        child: _loading 
                          ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3, color: isDark ? Colors.black : Colors.white))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.black : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.check, color: AppTheme.primary, size: 16),
                                ),
                                const SizedBox(width: 12),
                                const Text('Save Transaction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}

class _TypeToggleBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _TypeToggleBtn({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          boxShadow: isActive ? [
            BoxShadow(color: activeColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 1)
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive 
                ? (isDark ? Colors.black : Colors.white) 
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class _AddCategoryBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCategoryBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.1),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: AppTheme.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              'Add New',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBtn extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryBtn({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.1) : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : colorScheme.onSurface.withOpacity(0.05),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: AppTheme.primary.withOpacity(0.2), blurRadius: 10, spreadRadius: 1)
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primary : colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DetailsCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onSurfaceVariant, size: 24),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(color: colorScheme.onSurface, fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove commas to get raw number
    String text = newValue.text.replaceAll(',', '');
    
    // Parse to int
    final intValue = int.tryParse(text);
    if (intValue == null) return oldValue;

    // Format with commas
    final formatter = NumberFormat('#,###');
    String newText = formatter.format(intValue);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
