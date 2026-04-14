{{-- resources/views/livewire/dashboard.blade.php --}}
<div class="space-y-6">

    {{-- Header --}}
    <div class="flex items-center justify-between">
        <div>
            <h1 class="text-2xl font-bold text-gray-900">
                Halo, {{ Auth::user()->name }} 👋
            </h1>
            <p class="text-sm text-gray-500 mt-1">
                {{ \Carbon\Carbon::create()->month($month)->locale('id')->monthName }} {{ $year }}
            </p>
        </div>
        <div class="flex items-center gap-3">
            <select wire:model.live="month"
                class="bg-white border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-green-500">
                @foreach(range(1,12) as $m)
                    <option value="{{ $m }}">
                        {{ \Carbon\Carbon::create()->month($m)->locale('id')->monthName }}
                    </option>
                @endforeach
            </select>
            <select wire:model.live="year"
                class="bg-white border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-green-500">
                @foreach(range(2023, now()->year) as $y)
                    <option value="{{ $y }}">{{ $y }}</option>
                @endforeach
            </select>
        </div>
    </div>

    {{-- Summary Cards --}}
    <div class="grid grid-cols-3 gap-4">
        {{-- Balance --}}
        <div class="bg-gradient-to-br from-green-500 to-green-700 rounded-2xl p-6 text-white shadow-lg shadow-green-200">
            <p class="text-sm text-green-100 font-medium mb-2">Saldo Bulan Ini</p>
            <p class="text-3xl font-extrabold tracking-tight">
                Rp {{ number_format($balance, 0, ',', '.') }}
            </p>
            <div class="flex gap-4 mt-4">
                <div>
                    <p class="text-xs text-green-200">Pemasukan</p>
                    <p class="text-sm font-semibold">Rp {{ number_format($totalIncome, 0, ',', '.') }}</p>
                </div>
                <div>
                    <p class="text-xs text-green-200">Pengeluaran</p>
                    <p class="text-sm font-semibold">Rp {{ number_format($totalExpense, 0, ',', '.') }}</p>
                </div>
            </div>
        </div>

        {{-- Income --}}
        <div class="bg-white border border-gray-100 rounded-2xl p-6">
            <div class="flex items-center gap-2 mb-3">
                <span class="w-3 h-3 rounded-full bg-green-500"></span>
                <p class="text-sm text-gray-500 font-medium">Total Pemasukan</p>
            </div>
            <p class="text-2xl font-bold text-green-600">
                Rp {{ number_format($totalIncome, 0, ',', '.') }}
            </p>
        </div>

        {{-- Expense --}}
        <div class="bg-white border border-gray-100 rounded-2xl p-6">
            <div class="flex items-center gap-2 mb-3">
                <span class="w-3 h-3 rounded-full bg-red-500"></span>
                <p class="text-sm text-gray-500 font-medium">Total Pengeluaran</p>
            </div>
            <p class="text-2xl font-bold text-red-500">
                Rp {{ number_format($totalExpense, 0, ',', '.') }}
            </p>
        </div>
    </div>

    {{-- Chart + Recent --}}
    <div class="grid grid-cols-5 gap-4">

        {{-- Bar Chart --}}
        <div class="col-span-3 bg-white border border-gray-100 rounded-2xl p-6">
            <div class="flex items-center justify-between mb-4">
                <h2 class="font-semibold text-gray-800">Pemasukan vs Pengeluaran</h2>
                <div class="flex items-center gap-4 text-xs text-gray-500">
                    <span class="flex items-center gap-1.5">
                        <span class="w-3 h-3 rounded-sm bg-green-500 inline-block"></span>Pemasukan
                    </span>
                    <span class="flex items-center gap-1.5">
                        <span class="w-3 h-3 rounded-sm bg-red-400 inline-block"></span>Pengeluaran
                    </span>
                </div>
            </div>
            <div wire:ignore>
                <canvas id="barChart" height="160"></canvas>
            </div>
        </div>

        {{-- Recent --}}
        <div class="col-span-2 bg-white border border-gray-100 rounded-2xl p-6">
            <div class="flex items-center justify-between mb-4">
                <h2 class="font-semibold text-gray-800">Transaksi Terbaru</h2>
                <a href="{{ route('transactions') }}"
                    class="text-xs text-green-600 font-semibold hover:underline">
                    Lihat semua →
                </a>
            </div>
            <div class="space-y-3">
                @forelse($recent as $tx)
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl flex items-center justify-center text-lg flex-shrink-0
                        {{ $tx['type'] === 'income' ? 'bg-green-50' : 'bg-red-50' }}">
                        {{ $tx['category']['icon'] ?? '💰' }}
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="text-sm font-semibold text-gray-800 truncate">{{ $tx['title'] }}</p>
                        <p class="text-xs text-gray-400">{{ $tx['category']['name'] ?? 'Umum' }}</p>
                    </div>
                    <span class="text-sm font-bold {{ $tx['type'] === 'income' ? 'text-green-600' : 'text-red-500' }}">
                        {{ $tx['type'] === 'income' ? '+' : '-' }}Rp {{ number_format($tx['amount'], 0, ',', '.') }}
                    </span>
                </div>
                @empty
                <p class="text-sm text-gray-400 text-center py-6">Belum ada transaksi</p>
                @endforelse
            </div>
        </div>
    </div>
</div>

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<script>
    let barChart;

    function initChart(data) {
        const ctx = document.getElementById('barChart').getContext('2d');
        if (barChart) barChart.destroy();

        const recent = data.slice(-6);
        barChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: recent.map(d => d.label),
                datasets: [
                    {
                        label: 'Pemasukan',
                        data: recent.map(d => d.income),
                        backgroundColor: '#1D9E75',
                        borderRadius: 6,
                        barPercentage: 0.45,
                    },
                    {
                        label: 'Pengeluaran',
                        data: recent.map(d => d.expense),
                        backgroundColor: '#E24B4A',
                        borderRadius: 6,
                        barPercentage: 0.45,
                    },
                ],
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: ctx => ' Rp ' + ctx.raw.toLocaleString('id-ID'),
                        },
                    },
                },
                scales: {
                    y: {
                        grid: { color: '#F5F7FA' },
                        ticks: {
                            callback: v => 'Rp ' + (v >= 1e6 ? (v/1e6).toFixed(1)+'Jt' : v.toLocaleString('id-ID')),
                            font: { size: 10 },
                            color: '#9CA3AF',
                        },
                    },
                    x: {
                        grid: { display: false },
                        ticks: { font: { size: 11 }, color: '#6B7280' },
                    },
                },
            },
        });
    }

    document.addEventListener('livewire:initialized', () => {
        initChart(@json($chartData));

        Livewire.hook('morph.updated', ({ el }) => {
            if (el.id === 'barChart') return;
            initChart(@json($chartData));
        });
    });
</script>
@endpush
