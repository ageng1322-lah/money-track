<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<style>
  body { font-family: 'DejaVu Sans', sans-serif; font-size: 12px; color: #1a1a2e; margin: 0; padding: 0; }
  .header { background: #1D9E75; color: white; padding: 24px 32px; }
  .header h1 { margin: 0; font-size: 22px; font-weight: 700; }
  .header p  { margin: 4px 0 0; opacity: .8; font-size: 12px; }
  .content { padding: 24px 32px; }
  .summary { display: flex; gap: 16px; margin-bottom: 24px; }
  .summary-card { flex: 1; padding: 16px; border-radius: 8px; border: 1px solid #e5e7eb; }
  .summary-label { font-size: 11px; color: #6b7280; margin-bottom: 4px; }
  .summary-value { font-size: 18px; font-weight: 700; }
  .income  { color: #1D9E75; }
  .expense { color: #E24B4A; }
  table { width: 100%; border-collapse: collapse; }
  th { background: #f5f7fa; padding: 10px 12px; text-align: left; font-size: 11px;
       color: #6b7280; font-weight: 600; border-bottom: 1px solid #e5e7eb; }
  td { padding: 10px 12px; border-bottom: 1px solid #f0f0f0; }
  .badge { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 10px; font-weight: 600; }
  .badge-income  { background: #E1F5EE; color: #0F6E56; }
  .badge-expense { background: #FEF2F2; color: #991b1b; }
  .footer { margin-top: 24px; text-align: center; font-size: 10px; color: #9ca3af; }
</style>
</head>
<body>
<div class="header">
  <h1>FinTrack — Laporan Transaksi</h1>
  <p>Dicetak pada {{ now()->format('d F Y, H:i') }}</p>
</div>
<div class="content">
  <div class="summary">
    <div class="summary-card">
      <div class="summary-label">Total Pemasukan</div>
      <div class="summary-value income">Rp {{ number_format($totalIncome, 0, ',', '.') }}</div>
    </div>
    <div class="summary-card">
      <div class="summary-label">Total Pengeluaran</div>
      <div class="summary-value expense">Rp {{ number_format($totalExpense, 0, ',', '.') }}</div>
    </div>
    <div class="summary-card">
      <div class="summary-label">Saldo</div>
      <div class="summary-value" style="color: #1a1a2e">
        Rp {{ number_format($totalIncome - $totalExpense, 0, ',', '.') }}
      </div>
    </div>
  </div>

  <table>
    <thead>
      <tr>
        <th>Tanggal</th>
        <th>Judul</th>
        <th>Kategori</th>
        <th>Tipe</th>
        <th style="text-align:right">Nominal</th>
      </tr>
    </thead>
    <tbody>
      @foreach ($transactions as $tx)
      <tr>
        <td>{{ $tx->date->format('d M Y') }}</td>
        <td>{{ $tx->title }}</td>
        <td>{{ $tx->category?->icon }} {{ $tx->category?->name ?? 'Umum' }}</td>
        <td>
          <span class="badge badge-{{ $tx->type }}">
            {{ $tx->type === 'income' ? 'Pemasukan' : 'Pengeluaran' }}
          </span>
        </td>
        <td style="text-align:right; font-weight:600;
          color:{{ $tx->type === 'income' ? '#1D9E75' : '#E24B4A' }}">
          {{ $tx->type === 'income' ? '+' : '-' }}Rp {{ number_format($tx->amount, 0, ',', '.') }}
        </td>
      </tr>
      @endforeach
    </tbody>
  </table>

  <div class="footer">
    <p>Dokumen ini dibuat otomatis oleh FinTrack &bull; {{ $transactions->count() }} transaksi</p>
  </div>
</div>
</body>
</html>
