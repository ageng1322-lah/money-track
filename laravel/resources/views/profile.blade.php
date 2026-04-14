{{-- resources/views/profile.blade.php --}}
<x-layouts.app>
    <x-slot name="title">Profile</x-slot>

    <div class="max-w-5xl mx-auto animate-in fade-in duration-700 space-y-10">
        
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {{-- Personal Info Card --}}
            <div class="lg:col-span-2 bg-[#111111] rounded-[3rem] p-10 border border-white/5 shadow-2xl relative overflow-hidden">
                <div class="absolute top-[-5%] right-[-5%] w-64 h-64 bg-emerald-500/5 rounded-full blur-3xl"></div>
                
                <div class="flex flex-col sm:flex-row items-center gap-10 mb-12 pb-12 border-b border-white/[0.05]">
                    <div class="w-32 h-32 rounded-[2.5rem] bg-emerald-500 flex items-center justify-center text-black font-black text-5xl shadow-2xl shadow-emerald-500/20 italic">
                        {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                    </div>
                    <div class="text-center sm:text-left flex-1 min-w-0">
                        <h2 class="text-4xl font-outfit font-black text-white italic truncate">{{ Auth::user()->name }}</h2>
                        <p class="text-[11px] font-black text-white/20 uppercase tracking-[0.4em] mt-2 italic">{{ Auth::user()->email }}</p>
                        <div class="mt-6 flex flex-wrap gap-3 justify-center sm:justify-start">
                            <span class="px-4 py-2 bg-emerald-500/10 border border-emerald-500/20 text-emerald-500 text-[9px] font-black uppercase tracking-[0.2em] rounded-xl italic">Full Access</span>
                            <span class="px-4 py-2 bg-white/5 border border-white/10 text-white/40 text-[9px] font-black uppercase tracking-[0.2em] rounded-xl italic">Verified Identity</span>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-10">
                    <div>
                        <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block mb-3 px-1">Display Name</label>
                        <div class="bg-black border border-white/5 rounded-2xl px-6 py-4 text-sm font-bold text-white/60 font-outfit">{{ Auth::user()->name }}</div>
                    </div>
                    <div>
                        <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block mb-3 px-1">Email Terminal</label>
                        <div class="bg-black border border-white/5 rounded-2xl px-6 py-4 text-sm font-bold text-white/60 font-outfit">{{ Auth::user()->email }}</div>
                    </div>
                    <div class="sm:col-span-2">
                        <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block mb-3 px-1">Active Since</label>
                        <div class="bg-black border border-white/5 rounded-2xl px-6 py-4 text-sm font-bold text-white/60 font-outfit italic">{{ Auth::user()->created_at->translatedFormat('d F Y (H:i)') }}</div>
                    </div>
                </div>

                <div class="mt-12 flex gap-4">
                    <button class="px-10 py-5 bg-emerald-500 hover:bg-emerald-400 text-black rounded-2xl text-[10px] font-black uppercase tracking-[0.25em] shadow-2xl shadow-emerald-500/20 transition-all active:scale-[0.98]">
                        Edit Credentials
                    </button>
                    <button class="px-10 py-5 bg-white/5 border border-white/10 text-white/40 hover:bg-white/10 rounded-2xl text-[10px] font-black uppercase tracking-[0.25em] transition-all active:scale-[0.98]">
                        Security Console
                    </button>
                </div>
            </div>

            {{-- Terminal / Summary --}}
            <div class="space-y-8">
                <div class="bg-[#111111] rounded-[3rem] p-8 border border-white/5 shadow-2xl relative group overflow-hidden">
                    <div class="absolute inset-0 bg-emerald-500 opacity-0 group-hover:opacity-[0.02] transition-opacity"></div>
                    <h5 class="text-[10px] font-black text-white/20 uppercase tracking-[0.3em] mb-10 px-2">Account Statistics</h5>
                    <div class="space-y-10">
                        <div class="flex items-center justify-between px-2">
                            <div>
                                <p class="text-[9px] font-black text-white/20 uppercase tracking-widest">Total Transaction</p>
                                <p class="text-3xl font-black text-white font-outfit mt-1">{{ \App\Models\Transaction::where('user_id', Auth::id())->count() }}</p>
                            </div>
                            <div class="w-12 h-12 rounded-xl bg-emerald-500/10 flex items-center justify-center text-emerald-500">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                                </svg>
                            </div>
                        </div>
                        <div class="flex items-center justify-between px-2">
                            <div>
                                <p class="text-[9px] font-black text-white/20 uppercase tracking-widest">Cloud Capacity</p>
                                <p class="text-3xl font-black text-white font-outfit mt-1 italic">99<span class="text-xs text-white/40 font-bold ml-1">% FREE</span></p>
                            </div>
                            <div class="w-12 h-12 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-500">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 15a4 4 0 004 4h9a5 5 0 10-.1-9.999 5.002 5.002 0 10-9.78 2.096A4.001 4.001 0 003 15z" />
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="bg-rose-500/5 rounded-[3rem] p-8 border border-rose-500/10 relative group text-center">
                    <h5 class="text-[10px] font-black text-rose-500/40 mb-4 uppercase tracking-[0.4em]">Danger Zone</h5>
                    <p class="text-[11px] text-rose-500/30 font-bold leading-relaxed mb-8 px-4">Permanent account deletion will wipe all transaction history and categorized data. This action is not reversible.</p>
                    <button class="w-full py-5 bg-rose-500 hover:bg-rose-600 text-black rounded-[1.8rem] text-[10px] font-black uppercase tracking-[0.3em] shadow-2xl shadow-rose-500/20 transition-all active:scale-[0.98] italic">
                        Destroy Instance
                    </button>
                </div>
            </div>
        </div>
    </div>
</x-layouts.app>
