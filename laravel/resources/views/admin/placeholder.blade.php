<x-admin-layout>
    @section('header_title', strtoupper($title))

    <div class="space-y-10 animate-in fade-in duration-700">
        {{-- Header --}}
        <div class="flex flex-col gap-1  pb-8">
            <h1 class="text-3xl font-outfit font-black text-white tracking-tighter italic uppercase">{{ $title }} <span class="text-emerald-500">Node</span></h1>
            <p class="text-[9px] font-black text-white/20 uppercase tracking-[0.4em] ml-1">Feature implementation in progress</p>
        </div>

        <div class="bg-[#111111] rounded-[2.5rem] p-16 border border-white/[0.05] shadow-2xl text-center space-y-8 relative overflow-hidden">
            <div class="absolute inset-0 bg-emerald-500/[0.02] animate-pulse"></div>
            
            <div class="w-24 h-24 bg-emerald-500/10 rounded-[2rem] flex items-center justify-center mx-auto text-emerald-500 border border-emerald-500/10 relative z-10">
                <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path></svg>
            </div>
            
            <div class="space-y-3 relative z-10">
                <h2 class="text-2xl font-outfit font-black text-white italic uppercase tracking-tighter">Under Development</h2>
                <p class="text-white/30 max-w-sm mx-auto text-[11px] font-bold leading-relaxed italic uppercase tracking-widest">Protocol is being initialized. The {{ strtolower($title) }} management module will be active shortly.</p>
            </div>

            <div class="pt-6 relative z-10">
                <a href="{{ route('admin.dashboard') }}" class="inline-flex items-center gap-3 px-10 py-5 bg-emerald-500 text-black font-black uppercase tracking-[0.2em] text-[10px] rounded-2xl hover:bg-emerald-400 hover:scale-105 transition-all shadow-xl shadow-emerald-500/10 active:scale-95 italic">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="4"><path stroke-linecap="round" stroke-linejoin="round" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                    Return to Control Center
                </a>
            </div>
        </div>
    </div>
</x-admin-layout>

