<x-admin-layout>
    @section('header_title', 'METRICS ANALYTICS')

    <div class="space-y-12 animate-in fade-in duration-1000 p-5">

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {{-- Metric 1 --}}
            <div class="bg-[#111111] rounded-[2.5rem] p-10 border border-white/[0.05] shadow-2xl hover:border-emerald-500/20 transition-all duration-500 group relative overflow-hidden">
                <div class="absolute top-0 right-0 w-32 h-32 bg-emerald-500/5 rounded-full blur-3xl -mr-16 -mt-16 group-hover:bg-emerald-500/10 transition-colors"></div>
                <div class="flex justify-between items-start mb-10 relative z-10">
                    <div class="w-16 h-16 bg-emerald-500/10 rounded-2xl flex items-center justify-center text-emerald-500 border border-emerald-500/10 group-hover:bg-emerald-500 group-hover:text-black transition-all duration-500">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
                        </svg>
                    </div>
                    <span class="text-[9px] font-black text-emerald-500/40 uppercase tracking-[0.3em] bg-emerald-500/5 px-4 py-2 rounded-full border border-emerald-500/10">Identity Hub</span>
                </div>
                <div class="space-y-1 relative z-10">
                    <h4 class="text-[9px] font-black text-white/20 uppercase tracking-[0.2em] ml-1">Total registered users</h4>
                    <div class="text-5xl font-outfit font-black text-white tracking-tighter italic">{{ number_format($stats['total_users']) }}</div>
                </div>
            </div>

            {{-- Metric 2 --}}
            <div class="bg-[#111111] rounded-[2.5rem] p-10 border border-white/[0.05] shadow-2xl hover:border-blue-500/20 transition-all duration-500 group relative overflow-hidden">
                <div class="absolute top-0 right-0 w-32 h-32 bg-blue-500/5 rounded-full blur-3xl -mr-16 -mt-16 group-hover:bg-blue-500/10 transition-colors"></div>
                <div class="flex justify-between items-start mb-10 relative z-10">
                    <div class="w-16 h-16 bg-blue-500/10 rounded-2xl flex items-center justify-center text-blue-500 border border-blue-500/10 group-hover:bg-blue-500 group-hover:text-black transition-all duration-500">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path>
                        </svg>
                    </div>
                    <span class="text-[9px] font-black text-blue-500/40 uppercase tracking-[0.3em] bg-blue-500/5 px-4 py-2 rounded-full border border-blue-500/10">Data Traffic</span>
                </div>
                <div class="space-y-1 relative z-10">
                    <h4 class="text-[9px] font-black text-white/20 uppercase tracking-[0.2em] ml-1">Recorded transactions</h4>
                    <div class="text-5xl font-outfit font-black text-white tracking-tighter italic">{{ number_format($stats['total_transactions']) }}</div>
                </div>
            </div>

            {{-- Metric 3 --}}
            <div class="bg-[#111111] rounded-[2.5rem] p-10 border border-white/[0.05] shadow-2xl hover:border-purple-500/20 transition-all duration-500 group relative overflow-hidden">
                <div class="absolute top-0 right-0 w-32 h-32 bg-purple-500/5 rounded-full blur-3xl -mr-16 -mt-16 group-hover:bg-purple-500/10 transition-colors"></div>
                <div class="flex justify-between items-start mb-10 relative z-10">
                    <div class="w-16 h-16 bg-purple-500/10 rounded-2xl flex items-center justify-center text-purple-500 border border-purple-500/10 group-hover:bg-purple-500 group-hover:text-black transition-all duration-500">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
                        </svg>
                    </div>
                    <span class="text-[9px] font-black text-purple-500/40 uppercase tracking-[0.3em] bg-purple-500/5 px-4 py-2 rounded-full border border-purple-500/10">Schema Load</span>
                </div>
                <div class="space-y-1 relative z-10">
                    <h4 class="text-[9px] font-black text-white/20 uppercase tracking-[0.2em] ml-1">Platform categories</h4>
                    <div class="text-5xl font-outfit font-black text-white tracking-tighter italic">{{ number_format($stats['total_categories']) }}</div>
                </div>
            </div>
        </div>
    </div>
</x-admin-layout>

