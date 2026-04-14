<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<style>
  body { font-family: 'DejaVu Sans', sans-serif; font-size: 11px; color: #334155; margin: 0; padding: 0; }
  .header { background: #059669; color: white; padding: 30px 40px; }
  .header h1 { margin: 0; font-size: 24px; letter-spacing: -1px; }
  .header p  { margin: 5px 0 0; opacity: .8; font-size: 11px; font-weight: bold; text-transform: uppercase; letter-spacing: 1px; }
  .content { padding: 30px 40px; }
  .summary { margin-bottom: 30px; width: 100%; }
  .summary td { border: none !important; padding: 0 !important; width: 33.33%; }
  .summary-card { margin-right: 15px; padding: 15px; border-radius: 12px; background: #f8fafc; border: 1px solid #e2e8f0; }
  .summary-label { font-size: 9px; color: #64748b; font-weight: bold; text-transform: uppercase; margin-bottom: 5px; letter-spacing: 0.5px; }
  .summary-value { font-size: 16px; font-weight: bold; }
  .income  { color: #059669; }
  .expense { color: #e11d48; }
  
  table { width: 100%; border-collapse: collapse; margin-top: 20px; }
  th { background: #f8fafc; padding: 12px 15px; text-align: left; font-size: 9px;
       color: #64748b; font-weight: bold; text-transform: uppercase; border-bottom: 2px solid #e2e8f0; }
  td { padding: 12px 15px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
  
  .badge { display: inline-block; padding: 3px 10px; border-radius: 6px; font-size: 9px; font-weight: bold; }
  .badge-income  { background: #ecfdf5; color: #059669; }
  .badge-expense { background: #fff1f2; color: #be123c; }
  
  .footer { margin-top: 40px; text-align: center; font-size: 9px; color: #94a3b8; font-weight: bold; }
  .page-number:before { content: "Halaman " counter(page); }
</style>
</head>
<body>
<div class="header">
  <h1>MoneyTrack</h1>
  <p>Laporan Transaksi Keuangan</p>
</div>
<div class="content">
  <table class="summary">
    <tr>
      <td>
        <div class="summary-card">
          <div class="summary-label">Pemasukan</div>
          <div class="summary-value income">Rp {{ number_format($totalIncome, 0, ',', '.') }}</div>
        </div>
      </td>
      <td>
        <div class="summary-card">
          <div class="summary-label">Pengeluaran</div>
          <div class="summary-value expense">Rp {{ number_format($totalExpense, 0, ',', '.') }}</div>
        </div>
      </td>
      <td>
        <div class="summary-card">
          <div class="summary-label">Saldo Akhir</div>
          <div class="summary-value" style="color: #0f172a">
            Rp {{ number_format($totalIncome - $totalExpense, 0, ',', '.') }}
          </div>
        </div>
      </td>
    </tr>
  </table>

  <table>
    <thead>
      <tr>
        <th>Tanggal</th>
        <th>Deskripsi Transaksi</th>
        <th>Kategori</th>
        <th>Tipe</th>
        <th style="text-align:right">Nominal</th>
      </tr>
    </thead>
    <tbody>
      @foreach ($transactions as $tx)
      <tr>
        <td style="color: #64748b">{{ $tx->date->format('d/m/Y') }}</td>
        <td style="font-weight: bold; color: #1e293b">{{ $tx->title }}</td>
        <td>{{ $tx->category?->icon }} {{ $tx->category?->name ?? 'Umum' }}</td>
        <td>
          <span class="badge badge-{{ $tx->type }}">
            {{ $tx->type === 'income' ? 'PEMASUKAN' : 'PENGELUARAN' }}
          </span>
        </td>
        <td style="text-align:right; font-weight: bold;
          color:{{ $tx->type === 'income' ? '#059669' : '#e11d48' }}">
          {{ $tx->type === 'income' ? '+' : '-' }}Rp{{ number_format($tx->amount, 0, ',', '.') }}
        </td>
      </tr>
      @endforeach
    </tbody>
  </table>

  <div class="footer">
    <p>Laporan ini dihasilkan otomatis oleh MoneyTrack pada {{ now()->format('d M Y, H:i') }} &bull; Total {{ $transactions->count() }} Transaksi</p>
    <div class="page-number"></div>
  </div>
</div>
</body>
</html>
