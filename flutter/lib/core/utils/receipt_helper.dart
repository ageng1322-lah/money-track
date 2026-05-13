import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../features/transaction/domain/transaction_entity.dart';

class ReceiptHelper {
  static Future<void> generateAndShareReceipt(TransactionEntity tx) async {
    final pdf = pw.Document();
    final isExpense = tx.type == 'expense';
    final dateStr = DateFormat('MMM dd, yyyy').format(tx.date);
    final timeStr = DateFormat('HH:mm a').format(tx.date);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('MONEYTRACK', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Secure Financial Ledger', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text(tx.title.toUpperCase(), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(
                  '${isExpense ? '-' : '+'} Rp ${tx.amount.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
                  style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: isExpense ? PdfColors.red : PdfColors.green),
                ),
                pw.SizedBox(height: 30),
                _buildPdfRow('Transaction ID', '#TX-${tx.id}'),
                _buildPdfRow('Status', 'COMPLETED'),
                _buildPdfRow('Date', dateStr),
                _buildPdfRow('Time', timeStr),
                _buildPdfRow('Category', tx.category?.name ?? 'General'),
                if (tx.note != null && tx.note!.isNotEmpty) ...[
                  pw.SizedBox(height: 10),
                  pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Text('Note:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  pw.SizedBox(height: 5),
                  pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Text(tx.note!, style: const pw.TextStyle(fontSize: 10))),
                ],
                pw.SizedBox(height: 40),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text('Thank you for using MoneyTrack', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                pw.Text('Keep track, stay secure.', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'MoneyTrack_Receipt_${tx.id}.pdf',
    );
  }

  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
