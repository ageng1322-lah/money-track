// lib/features/transaction/presentation/transaction_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/providers/providers.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  final int? transactionId;
  const TransactionFormScreen({super.key, this.transactionId});

  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<TransactionFormScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _titleCtrl   = TextEditingController();
  final _amountCtrl  = TextEditingController();
  final _noteCtrl    = TextEditingController();

  String   _type        = 'expense';
  DateTime _date        = DateTime.now();
  int?     _categoryId;
  bool     _loading     = false;
  String?  _error;

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
    setState(() { _loading = true; _error = null; });

    try {
      final repo   = ref.read(transactionRepositoryProvider);
      final amount = double.parse(_amountCtrl.text.replaceAll('.', ''));

      if (isEdit) {
        await repo.updateTransaction(widget.transactionId!, {
          'title':       _titleCtrl.text.trim(),
          'amount':      amount,
          'type':        _type,
          'date':        DateFormatter.toApiDate(_date),
          'category_id': _categoryId,
          'note':        _noteCtrl.text.isEmpty ? null : _noteCtrl.text.trim(),
        });
      } else {
        await repo.createTransaction(
          title:      _titleCtrl.text.trim(),
          amount:     amount,
          type:       _type,
          date:       DateFormatter.toApiDate(_date),
          categoryId: _categoryId,
          note:       _noteCtrl.text.isEmpty ? null : _noteCtrl.text.trim(),
        );
      }

      ref.read(dashboardProvider.notifier).refresh();
      // Also invalidate transaction list
      // ref.invalidate(transactionListProvider); // if exists
      
      if (mounted) getx.Get.back();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context:    context,
      initialDate: _date,
      firstDate:   DateTime(2020),
      lastDate:    DateTime.now(),
      builder: (context, child) => Theme(
        data: AppTheme.dark.copyWith(
          colorScheme: const ColorScheme.dark(primary: AppTheme.primary, surface: AppTheme.surface),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Recording' : 'New Recording'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => getx.Get.back(),
        ),
      ),
      body: _loading && isEdit 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Type toggle
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color:        AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border:       Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(children: [
                _TypeButton(label: 'Expense',
                  active: _type == 'expense', color: AppTheme.expense,
                  onTap:  () => setState(() => _type = 'expense')),
                _TypeButton(label: 'Income',
                  active: _type == 'income',  color: AppTheme.income,
                  onTap:  () => setState(() => _type = 'income')),
              ]),
            ),
            const SizedBox(height: 32),

            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:  AppTheme.expense.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.expense.withOpacity(0.2)),
                ),
                child: Text(_error!, style: const TextStyle(color: AppTheme.expense, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
            ],

            // Amount input
            Text('Amount', style: TextStyle(color: AppTheme.textDim, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, fontFamily: 'Outfit'),
              decoration: InputDecoration(
                prefixText: 'Rp ',
                prefixStyle: TextStyle(color: AppTheme.textDim, fontSize: 24, fontWeight: FontWeight.bold),
                hintText: '0',
                fillColor: Colors.transparent,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 32),

            // Form Fields
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'DESCRIPTION',
                hintText: 'What did you buy/earn?',
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 20),

            Row(children: [
              Expanded(
                child: InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(20),
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'DATE'),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(_date),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _categoryId,
                  decoration: const InputDecoration(labelText: 'CATEGORY'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('General')),
                    // In a real app, you'd fetch categories here
                  ],
                  onChanged: (v) => setState(() => _categoryId = v),
                ),
              ),
            ]),
            const SizedBox(height: 20),

            TextFormField(
              controller: _noteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'NOTES (OPTIONAL)',
                hintText: 'Add some details...',
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black))
                : Text(isEdit ? 'UPDATE RECORD' : 'SAVE TRANSACTION'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool active; final Color color;
  final VoidCallback onTap;
  const _TypeButton({required this.label, required this.active, required this.color, required this.onTap});

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
          boxShadow: active ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : null,
        ),
        child: Center(
          child: Text(label.toUpperCase(), style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5,
            color: active ? Colors.black : AppTheme.textDim)),
        ),
      ),
    ),
  );
}
