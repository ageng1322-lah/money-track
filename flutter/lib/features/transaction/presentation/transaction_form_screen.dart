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
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final repo = ref.read(transactionRepositoryProvider);
      final amount = double.parse(_amountCtrl.text.replaceAll('.', ''));

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

      if (mounted) getx.Get.back();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Recording' : 'New Recording'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => getx.Get.back(),
        ),
      ),
      body: _loading && isEdit
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Type toggle
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 100),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.05)),
                      ),
                      child: Row(children: [
                        _TypeButton(
                            label: 'Expense',
                            active: _type == 'expense',
                            color: AppTheme.expense,
                            onTap: () => setState(() {
                                  _type = 'expense';
                                  _categoryId =
                                      null; // Reset category when switching type
                                })),
                        _TypeButton(
                            label: 'Income',
                            active: _type == 'income',
                            color: AppTheme.income,
                            onTap: () => setState(() {
                                  _type = 'income';
                                  _categoryId =
                                      null; // Reset category when switching type
                                })),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 32),

                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.expense.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppTheme.expense.withOpacity(0.2)),
                      ),
                      child: Text(_error!,
                          style: const TextStyle(
                              color: AppTheme.expense,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Amount input
                  // Amount input
                  const FadeInAnimation(
                    delay: Duration(milliseconds: 200),
                    child: Text('Amount',
                        style: TextStyle(
                            color: AppTheme.lightTextDim,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5)),
                  ),
                  const SizedBox(height: 12),
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 300),
                    child: TextFormField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Outfit'),
                      decoration: InputDecoration(
                        prefixText: 'Rp ',
                        prefixStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        hintText: '0',
                        fillColor: Colors.transparent,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Description Field
            FadeInAnimation(
              delay: const Duration(milliseconds: 400),
              child: TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'DESCRIPTION',
                  hintText: 'What did you buy/earn?',
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 32),

            // Category Selection (Grid)
            const FadeInAnimation(
              delay: Duration(milliseconds: 500),
              child: Text('CATEGORY', style: TextStyle(color: AppTheme.lightTextDim, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            ),
            const SizedBox(height: 16),
            categoriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
              error: (err, _) => const Text('Error loading categories'),
              data: (categories) {
                // Showing all categories as requested, not filtering by _type
                final displayCategories = categories;
                
                return FadeInAnimation(
                  delay: const Duration(milliseconds: 600),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: displayCategories.length,
                    itemBuilder: (context, index) {
                      final cat = displayCategories[index];
                      final isSelected = _categoryId == cat.id;
                      
                      return GestureDetector(
                        onTap: () => setState(() {
                          _categoryId = cat.id;
                          // Optional: Auto-switch type if category is strictly income or expense
                          if (cat.type == 'income' || cat.type == 'expense') {
                            _type = cat.type;
                          }
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primary.withOpacity(0.1) : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected ? AppTheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                              width: 2,
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(color: AppTheme.primary.withOpacity(0.2), blurRadius: 15, spreadRadius: 1)
                            ] : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(cat.icon, style: const TextStyle(fontSize: 28)),
                              const SizedBox(height: 8),
                              Text(cat.name.toUpperCase(), 
                                style: TextStyle(
                                  fontSize: 9, 
                                  fontWeight: FontWeight.w900, 
                                  letterSpacing: 1,
                                  color: isSelected ? AppTheme.primary : Theme.of(context).colorScheme.onSurfaceVariant
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Notes field (Styled)
            FadeInAnimation(
              delay: const Duration(milliseconds: 700),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _noteCtrl,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Add a note...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                    Icon(Icons.notes_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date field (Styled)
            FadeInAnimation(
              delay: const Duration(milliseconds: 800),
              child: GestureDetector(
                onTap: _pickDate,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE, dd MMM yyyy').format(_date),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.calendar_month_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),

            FadeInAnimation(
              delay: const Duration(milliseconds: 900),
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: _loading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black))
                  : Text(isEdit ? 'UPDATE RECORD' : 'SAVE TRANSACTION'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;
  const _TypeButton(
      {required this.label,
      required this.active,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: active ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: active
                  ? [
                      BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ]
                  : null,
            ),
            child: Center(
              child: Text(label.toUpperCase(),
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: active
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white)
                          : Theme.of(context).colorScheme.onSurfaceVariant)),
            ),
          ),
        ),
      );
}
