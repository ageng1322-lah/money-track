// lib/features/transaction/presentation/transaction_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      if (mounted) context.pop();
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
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title:    Text(isEdit ? 'Edit Transaksi' : 'Tambah Transaksi'),
        leading:  IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
        actions: isEdit ? [
          IconButton(
            icon:  const Icon(Icons.delete_outline, color: AppTheme.expense),
            onPressed: () {},
          ),
        ] : null,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Type toggle
            Container(
              decoration: BoxDecoration(
                color:        AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border:       Border.all(color: AppTheme.divider, width: 0.5),
              ),
              child: Row(children: [
                _TypeButton(label: 'Pengeluaran', icon: '↑',
                  active: _type == 'expense', color: AppTheme.expense,
                  onTap:  () => setState(() => _type = 'expense')),
                _TypeButton(label: 'Pemasukan',   icon: '↓',
                  active: _type == 'income',  color: AppTheme.income,
                  onTap:  () => setState(() => _type = 'income')),
              ]),
            ),
            const SizedBox(height: 20),

            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:  const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(_error!, style: const TextStyle(color: AppTheme.expense, fontSize: 13)),
              ),
              const SizedBox(height: 16),
            ],

            // Amount (big input)
            Container(
              padding:      const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:        AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border:       Border.all(color: AppTheme.divider, width: 0.5),
              ),
              child: Column(children: [
                Text('Nominal',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Rp ', style: TextStyle(fontSize: 22,
                    fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                  Expanded(child: TextFormField(
                    controller:   _amountCtrl,
                    keyboardType: TextInputType.number,
                    textAlign:    TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700,
                      color: _type == 'income' ? AppTheme.income : AppTheme.expense),
                    decoration: const InputDecoration(
                      border:         InputBorder.none,
                      enabledBorder:  InputBorder.none,
                      focusedBorder:  InputBorder.none,
                      filled:         false,
                      hintText:       '0',
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Nominal wajib diisi';
                      final n = double.tryParse(v.replaceAll('.', ''));
                      if (n == null || n < 1) return 'Nominal tidak valid';
                      return null;
                    },
                  )),
                ]),
              ]),
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller:  _titleCtrl,
              decoration: const InputDecoration(
                labelText:  'Judul transaksi',
                prefixIcon:  Icon(Icons.title),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 14),

            // Date
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color:        const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border:       Border.all(color: AppTheme.divider),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined,
                    color: AppTheme.textSecondary, size: 20),
                  const SizedBox(width: 12),
                  Text(DateFormatter.formatDate(_date),
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15)),
                ]),
              ),
            ),
            const SizedBox(height: 14),

            // Note
            TextFormField(
              controller:  _noteCtrl,
              maxLines:    3,
              decoration: const InputDecoration(
                labelText:  'Catatan (opsional)',
                prefixIcon:  Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _type == 'income' ? AppTheme.income : AppTheme.expense,
              ),
              child: _loading
                  ? const SizedBox(width: 22, height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(isEdit ? 'Simpan Perubahan' : 'Simpan Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label; final String icon;
  final bool active;  final Color color;
  final VoidCallback onTap;
  const _TypeButton({required this.label, required this.icon,
    required this.active, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:  const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color:        active ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(icon, style: TextStyle(
            fontSize: 16, color: active ? Colors.white : AppTheme.textSecondary,
            fontWeight: FontWeight.w700)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppTheme.textSecondary)),
        ]),
      ),
    ),
  );
}
