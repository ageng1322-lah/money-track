<div>
    @section('header_title', 'INFRASTRUCTURE SETTINGS')

    <div class="max-w-5xl mx-auto space-y-12 animate-in fade-in slide-in-from-bottom-5 duration-700">

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
            {{-- Left Column: Forms --}}
            <div class="lg:col-span-2 space-y-8">
                {{-- Flash Message --}}
                @if (session()->has('message'))
                    <div class="p-6 bg-emerald-500/10 border border-emerald-500/20 rounded-2xl flex items-center gap-4 animate-in zoom-in-95">
                        <div class="w-10 h-10 rounded-xl bg-emerald-500 flex items-center justify-center text-black shadow-lg">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="3.5"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"></path></svg>
                        </div>
                        <p class="text-[10px] font-black text-emerald-500 uppercase tracking-widest italic">{{ session('message') }}</p>
                    </div>
                @endif

                {{-- Profile Info Card --}}
                <div class="bg-[#111111] rounded-[2.5rem] p-10 border border-white/[0.05] shadow-2xl relative overflow-hidden group">
                    <div class="absolute top-0 right-0 w-48 h-48 bg-emerald-500/5 rounded-full blur-3xl -mr-24 -mt-24 group-hover:bg-emerald-500/10 transition-colors"></div>
                    
                    <div class="flex items-center gap-4 mb-10 relative z-10">
                        <div class="w-10 h-10 rounded-xl bg-emerald-500/10 flex items-center justify-center text-emerald-500 border border-emerald-500/20">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                        </div>
                        <h2 class="text-lg font-outfit font-black text-white italic uppercase tracking-tight">Public Identity</h2>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 relative z-10">
                        <div class="space-y-3">
                            <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block px-1">Master Name</label>
                            <input type="text" wire:model="name" 
                                class="w-full bg-black border border-white/[0.08] rounded-xl px-6 py-4 text-sm font-bold text-white outline-none focus:ring-4 focus:ring-emerald-500/10 focus:border-emerald-500/30 transition-all">
                            @error('name') <span class="text-rose-500 text-[8px] font-black uppercase mt-1 block px-1 italic">{{ $message }}</span> @enderror
                        </div>

                        <div class="space-y-3">
                            <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block px-1">Admin Email</label>
                            <input type="email" wire:model="email" 
                                class="w-full bg-black border border-white/[0.08] rounded-xl px-6 py-4 text-sm font-bold text-white outline-none focus:ring-4 focus:ring-emerald-500/10 focus:border-emerald-500/30 transition-all">
                            @error('email') <span class="text-rose-500 text-[8px] font-black uppercase mt-1 block px-1 italic">{{ $message }}</span> @enderror
                        </div>
                    </div>

                    <div class="mt-10 relative z-10">
                        <button wire:click="updateProfile" 
                            class="w-full py-5 bg-emerald-500 text-black rounded-xl text-[10px] font-black uppercase tracking-[0.3em] shadow-xl shadow-emerald-500/10 hover:bg-emerald-400 active:scale-[0.98] transition-all">
                            Update Platform Identity
                        </button>
                    </div>
                </div>

                {{-- Security Card --}}
                <div class="bg-[#111111] rounded-[2.5rem] p-10 border border-white/[0.05] shadow-2xl relative overflow-hidden group">
                    <div class="absolute bottom-0 left-0 w-48 h-48 bg-rose-500/5 rounded-full blur-3xl -ml-24 -mb-24 group-hover:bg-rose-500/10 transition-colors"></div>
                    
                    <div class="flex items-center gap-4 mb-10 relative z-10">
                        <div class="w-10 h-10 rounded-xl bg-rose-500/10 flex items-center justify-center text-rose-500 border border-rose-500/20">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                        </div>
                        <h2 class="text-lg font-outfit font-black text-white italic uppercase tracking-tight">Security Protocols</h2>
                    </div>

                    <div class="space-y-8 relative z-10">
                        <div class="space-y-3">
                            <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block px-1">Current Auth Secret</label>
                            <input type="password" wire:model="current_password" 
                                class="w-full bg-black border border-white/[0.08] rounded-xl px-6 py-4 text-sm font-bold text-white outline-none focus:ring-4 focus:ring-rose-500/10 focus:border-rose-500/30 transition-all">
                            @error('current_password') <span class="text-rose-500 text-[8px] font-black uppercase mt-1 block px-1 italic">{{ $message }}</span> @enderror
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                            <div class="space-y-3">
                                <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block px-1">New Password</label>
                                <input type="password" wire:model="new_password" 
                                    class="w-full bg-black border border-white/[0.08] rounded-xl px-6 py-4 text-sm font-bold text-white outline-none focus:ring-4 focus:ring-emerald-500/10 focus:border-emerald-500/30 transition-all">
                                @error('new_password') <span class="text-rose-500 text-[8px] font-black uppercase mt-1 block px-1 italic">{{ $message }}</span> @enderror
                            </div>
                            <div class="space-y-3">
                                <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block px-1">Confirm New Password</label>
                                <input type="password" wire:model="new_password_confirmation" 
                                    class="w-full bg-black border border-white/[0.08] rounded-xl px-6 py-4 text-sm font-bold text-white outline-none focus:ring-4 focus:ring-emerald-500/10 focus:border-emerald-500/30 transition-all">
                            </div>
                        </div>
                    </div>

                    <div class="mt-10 relative z-10">
                        <button wire:click="updatePassword" 
                            class="w-full py-5 bg-white/5 border border-white/10 text-white/40 hover:text-white hover:bg-white/10 rounded-xl text-[9px] font-black uppercase tracking-[0.3em] active:scale-[0.98] transition-all">
                            Revise Security Access
                        </button>
                    </div>
                </div>
            </div>

            {{-- Right Column: Profile Summary --}}
            <div class="space-y-8 sticky top-32">
                <div class="bg-[#111111] rounded-[2.5rem] p-10 border border-white/[0.05] shadow-2xl text-center relative overflow-hidden group">
                    <div class="absolute inset-0 bg-emerald-500/5 opacity-0 group-hover:opacity-100 transition-opacity blur-3xl"></div>
                    
                    <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.4em] block mb-8 relative z-10">Administrative Avatar</label>
                    
                    <div class="relative inline-block group z-10">
                        <div class="w-40 h-40 rounded-[2.5rem] bg-black border-4 border-white/[0.05] p-2 group-hover:border-emerald-500 transition-all duration-700 shadow-2xl">
                            <div class="w-full h-full rounded-[2rem] bg-emerald-500 overflow-hidden flex items-center justify-center text-5xl font-outfit font-black text-black shadow-inner italic">
                                @if(auth()->user()->photo_url)
                                    <img src="{{ auth()->user()->photo_url }}" class="w-full h-full object-cover">
                                @else
                                    {{ strtoupper(substr(auth()->user()->name, 0, 1)) }}
                                @endif
                            </div>
                        </div>
                        
                        <label class="absolute -bottom-2 -right-2 w-12 h-12 bg-emerald-500 rounded-2xl border-4 border-black flex items-center justify-center text-black cursor-pointer hover:scale-110 active:scale-90 hover:bg-emerald-400 transition-all shadow-xl">
                            <input type="file" wire:model="photo" class="hidden">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="4"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"></path></svg>
                        </label>
                    </div>

                    <div class="mt-10 space-y-2 relative z-10">
                        <p class="text-2xl font-outfit font-black text-white italic tracking-tighter uppercase truncate">{{ auth()->user()->name }}</p>
                        <span class="text-[8px] font-black text-emerald-500 uppercase tracking-[0.3em] bg-emerald-500/5 px-4 py-2 rounded-full border border-emerald-500/10 inline-block italic">System Administrator</span>
                    </div>

                    <div class="mt-10 pt-8 border-t border-white/[0.03] relative z-10">
                        <p class="text-[9px] text-white/10 font-black leading-relaxed uppercase tracking-[0.1em] italic">All system modifications are logged and synced to the master node.</p>
                    </div>
                </div>

                <div class="bg-rose-500/5 rounded-[2.5rem] p-8 border border-rose-500/10 text-center space-y-4">
                    <h5 class="text-[9px] font-black text-rose-500/40 uppercase tracking-[0.3em]">System Node</h5>
                    <p class="text-[10px] text-rose-500/30 font-bold leading-relaxed px-4 italic">Primary Administrative Instance Active</p>
                </div>
            </div>
        </div>
    </div>
</div>

