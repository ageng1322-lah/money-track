{{-- resources/views/livewire/dashboard.blade.php --}}
<div class="space-y-10 animate-in fade-in duration-700">
    <x-slot name="title">DASHBOARD</x-slot>

    {{-- Filters --}}
    <div class="flex flex-wrap items-center justify-between gap-4">
        <div class="flex items-center gap-2">
            <div class="w-1.5 h-6 bg-emerald-500 rounded-full"></div>
            <h4 class="text-xs font-black text-white/40 uppercase tracking-[0.2em]">Ringkasan Finansial</h4>
        </div>
        <div class="flex items-center gap-3">
            <select wire:model.live="month" class="bg-[#111111] border border-white/5 text-white/60 text-xs font-bold rounded-xl px-4 py-2.5 outline-none focus:border-emerald-500/50 transition-all cursor-pointer">
                @foreach(range(1, 12) as $m)
                    <option value="{{ $m }}">{{ \Carbon\Carbon::create()->month($m)->format('F') }}</option>
                @endforeach
            </select>
            <select wire:model.live="year" class="bg-[#111111] border border-white/5 text-white/60 text-xs font-bold rounded-xl px-4 py-2.5 outline-none focus:border-emerald-500/50 transition-all cursor-pointer">
                @foreach(range(date('Y')-2, date('Y')+1) as $y)
                    <option value="{{ $y }}">{{ $y }}</option>
                @endforeach
            </select>
        </div>
    </div>

    {{-- Top Stats --}}
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        {{-- Total Balance --}}
        <div class="bg-[#111111] rounded-[2rem] p-8 border border-white/5 shadow-2xl relative overflow-hidden group">
            <div class="absolute top-0 right-0 p-6 opacity-10">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-16 h-16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" />
                </svg>
            </div>
            <div class="flex items-center gap-3 mb-6">
                <div class="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center text-white/40">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" />
                    </svg>
                </div>
                <span class="text-[10px] font-black text-white/40 uppercase tracking-[0.2em]">Total Saldo</span>
            </div>
            <h3 class="text-4xl font-outfit font-extrabold tracking-tight text-white">Rp{{ number_format($balance, 0, ',', '.') }}</h3>
        </div>

        {{-- Monthly Income --}}
        <div class="bg-[#111111] rounded-[2rem] p-8 border border-white/5 shadow-2xl group">
            <div class="flex items-center gap-3 mb-6">
                <div class="w-10 h-10 rounded-xl bg-emerald-500/10 flex items-center justify-center text-emerald-500">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 10l7-7m0 0l7 7m-7-7v18" />
                    </svg>
                </div>
                <span class="text-[10px] font-black text-white/40 uppercase tracking-[0.2em]">Pemasukan Bulan ini</span>
            </div>
            <h3 class="text-4xl font-outfit font-extrabold tracking-tight text-emerald-500">Rp{{ number_format($totalIncome, 0, ',', '.') }}</h3>
        </div>

        {{-- Monthly Expense --}}
        <div class="bg-[#111111] rounded-[2rem] p-8 border border-white/5 shadow-2xl group">
            <div class="flex items-center gap-3 mb-6">
                <div class="w-10 h-10 rounded-xl bg-rose-500/10 flex items-center justify-center text-rose-500">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M19 14l-7 7m0 0l-7-7m7 7V3" />
                    </svg>
                </div>
                <span class="text-[10px] font-black text-white/40 uppercase tracking-[0.2em]">Pengeluaran Bulan ini </span>
            </div>
            <h3 class="text-4xl font-outfit font-extrabold tracking-tight text-rose-500">Rp{{ number_format($totalExpense, 0, ',', '.') }}</h3>
        </div>
    </div>

    {{-- Main Content Grid --}}
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {{-- Chart Section --}}
        <div class="lg:col-span-7 bg-[#111111] rounded-[2.5rem] p-8 border border-white/5 shadow-2xl">
            <div class="flex items-center gap-3 mb-8">
                <div class="w-6 h-6 text-emerald-500">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                    </svg>
                </div>
                <h4 class="text-lg font-bold text-white">Perbandingan Keuangan</h4>
            </div>
            <div class="h-80 w-full">
                <canvas id="monthlyChart"></canvas>
            </div>
        </div>

        {{-- Recent Activity --}}
        <div class="lg:col-span-5 bg-[#111111] rounded-[2.5rem] p-8 border border-white/5 shadow-2xl">
            <div class="flex items-center gap-3 mb-8">
                <div class="w-6 h-6 text-emerald-500">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
                <h4 class="text-lg font-bold text-white">Riwayat Terakhir</h4>
            </div>
            
            <div class="space-y-4">
                @forelse($recent as $tx)
                    <div class="flex items-center gap-4 p-4 rounded-2xl bg-white/[0.02] border border-white/[0.05] group hover:bg-white/[0.05] transition-all duration-300">
                        <div class="w-12 h-12 rounded-xl flex items-center justify-center text-xl bg-black border border-white/5" 
                             style="color: {{ $tx['category']['color'] ?? '#ffffff' }}">
                            {{ $tx['category']['icon'] ?? '💰' }}
                        </div>
                        <div class="flex-1 min-w-0">
                            <h5 class="text-sm font-bold text-white truncate">{{ $tx['title'] }}</h5>
                            <p class="text-[10px] text-white/20 font-black uppercase tracking-widest mt-0.5">{{ $tx['category']['name'] ?? 'Umum' }}</p>
                        </div>
                        <div class="text-right">
                            <p class="text-sm font-black {{ $tx['type'] === 'income' ? 'text-emerald-500' : 'text-rose-500' }}">
                                {{ $tx['type'] === 'income' ? '+' : '-' }}Rp{{ number_format($tx['amount'], 0, ',', '.') }}
                            </p>
                        </div>
                    </div>
                @empty
                    <div class="text-center py-10 opacity-20">
                        <p class="text-sm font-bold uppercase tracking-widest">Belum ada aktivitas</p>
                    </div>
                @endforelse
            </div>
        </div>
    </div>

    @push('scripts')
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener('livewire:initialized', () => {
            const ctx = document.getElementById('monthlyChart').getContext('2d');
            let chartData = @json($chartData);
            
            const renderChart = (data) => {
                return new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(i => i.label),
                        datasets: [
                            {
                                label: 'Pemasukan',
                                data: data.map(i => i.income),
                                backgroundColor: '#10b981',
                                borderRadius: 8,
                                barThickness: 12,
                            },
                            {
                                label: 'Pengeluaran',
                                data: data.map(i => i.expense),
                                backgroundColor: '#f43f5e',
                                borderRadius: 8,
                                barThickness: 12,
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: document.body.classList.contains('light-mode') ? '#ffffff' : '#111111',
                                titleFont: { family: 'Outfit', size: 14 },
                                bodyFont: { family: 'Inter', size: 12 },
                                padding: 12,
                                cornerRadius: 12,
                                borderColor: document.body.classList.contains('light-mode') ? 'rgba(0,0,0,0.1)' : 'rgba(255,255,255,0.1)',
                                borderWidth: 1,
                                titleColor: document.body.classList.contains('light-mode') ? '#0f172a' : '#ffffff',
                                bodyColor: document.body.classList.contains('light-mode') ? '#64748b' : 'rgba(255,255,255,0.6)'
                            }
                        },
                        scales: {
                            x: {
                                grid: { display: false },
                                ticks: { 
                                    color: document.body.classList.contains('light-mode') ? 'rgba(15,23,42,0.4)' : 'rgba(255,255,255,0.2)', 
                                    font: { family: 'Inter', weight: 'bold', size: 10 } 
                                }
                            },
                            y: {
                                grid: { 
                                    color: document.body.classList.contains('light-mode') ? 'rgba(0,0,0,0.05)' : 'rgba(255,255,255,0.05)', 
                                    drawTicks: false 
                                },
                                border: { display: false },
                                ticks: { 
                                    color: document.body.classList.contains('light-mode') ? 'rgba(15,23,42,0.4)' : 'rgba(255,255,255,0.2)', 
                                    font: { family: 'Inter', weight: 'bold', size: 10 },
                                    callback: v => v >= 1000000 ? (v/1000000)+'M' : (v >= 1000 ? (v/1000)+'K' : v)
                                }
                            }
                        }
                    }
                });
            };

            let myChart = renderChart(chartData);
            
            window.addEventListener('theme-changed', () => {
                myChart.destroy();
                myChart = renderChart(chartData);
            });

            Livewire.on('chartUpdated', (data) => {
                chartData = data[0];
                myChart.destroy();
                myChart = renderChart(chartData);
            });
        });
    </script>
    @endpush
</div>
