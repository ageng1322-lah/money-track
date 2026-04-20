{{-- resources/views/profile.blade.php --}}
<x-layouts.app>
    <x-slot name="title">PROFILE</x-slot>

    <div class="max-w-5xl mx-auto animate-in fade-in duration-700 space-y-10">
        
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {{-- Personal Info Card --}}
            <div class="lg:col-span-2 bg-[#111111] rounded-[3rem] p-10 border border-white/5 shadow-2xl relative overflow-hidden">
                <div class="absolute top-[-5%] right-[-5%] w-64 h-64 bg-emerald-500/5 rounded-full blur-3xl"></div>
                
                <form id="profile-form" action="{{ route('profile.update') }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')

                    <div class="flex flex-col sm:flex-row items-center gap-10 mb-12 pb-12 border-b border-white/[0.05]">
                        <div class="relative group">
                            {{-- Profile Photo Container --}}
                            <div class="w-32 h-32 rounded-[2.5rem] bg-emerald-500 overflow-hidden flex items-center justify-center text-black font-black text-5xl shadow-2xl shadow-emerald-500/20 italic relative">
                                @if(Auth::user()->photo_url)
                                    <img src="{{ Auth::user()->photo_url }}" alt="{{ Auth::user()->name }}" class="w-full h-full object-cover">
                                @else
                                    {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                                @endif
                                
                                {{-- Hover Overlay --}}
                                <div onclick="document.getElementById('photo-input').click()" class="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center cursor-pointer">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                                    </svg>
                                </div>
                            </div>

                            {{-- Camera Icon Badge --}}
                            <div onclick="document.getElementById('photo-input').click()" class="absolute -bottom-1 -right-1 w-10 h-10 bg-emerald-500 border-4 border-[#111111] rounded-2xl flex items-center justify-center text-black shadow-xl cursor-pointer hover:scale-110 transition-transform z-10">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                                    <path fill-rule="evenodd" d="M4 5a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V7a2 2 0 00-2-2h-1.586a1 1 0 01-.707-.293l-1.121-1.121A2 2 0 0011.172 3H8.828a2 2 0 00-1.414.586L6.293 4.707A1 1 0 015.586 5H4zm6 9a3 3 0 100-6 3 3 0 000 6z" clip-rule="evenodd" />
                                </svg>
                            </div>

                            <input type="file" name="photo" id="photo-input" class="hidden" onchange="this.form.submit()">
                        </div>

                        <div class="text-center sm:text-left flex-1 min-w-0">
                            <h2 class="text-4xl font-outfit font-black text-white italic truncate">{{ Auth::user()->name }}</h2>
                            <p class="text-[11px] font-black text-white/20 uppercase tracking-[0.4em] mt-2 italic">{{ Auth::user()->email }}</p>
                            
                            <div class="flex flex-wrap items-center gap-4 mt-4">
                                @if (session('status') === 'profile-updated')
                                    <p class="text-emerald-500 text-[10px] font-bold animate-pulse capitalize">✓ Profile database updated</p>
                                @endif
                                @if (session('status') === 'photo-deleted')
                                    <p class="text-rose-500 text-[10px] font-bold animate-pulse capitalize">✓ Photo deleted</p>
                                @endif
                                
                                @if(Auth::user()->photo)
                                    <button type="button" onclick="if(confirm('Hapus foto profil?')) document.getElementById('delete-photo-form').submit();" class="text-rose-500/50 hover:text-rose-500 text-[9px] font-black uppercase tracking-widest transition-colors flex items-center gap-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" viewBox="0 0 20 20" fill="currentColor">
                                            <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
                                        </svg>
                                        Remove Avatar
                                    </button>
                                @endif
                            </div>

                            <div class="mt-6 flex flex-wrap gap-3 justify-center sm:justify-start">
                                <span class="px-4 py-2 bg-emerald-500/10 border border-emerald-500/20 text-emerald-500 text-[9px] font-black uppercase tracking-[0.2em] rounded-xl italic">Full Access</span>
                                <span class="px-4 py-2 bg-white/5 border border-white/10 text-white/40 text-[9px] font-black uppercase tracking-[0.2em] rounded-xl italic">Verified Identity</span>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-10">
                        <div>
                            <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block mb-3 px-1">Display Name</label>
                            <input type="text" name="name" id="name-input" value="{{ old('name', Auth::user()->name) }}" class="w-full bg-black border border-white/5 rounded-2xl px-6 py-4 text-sm font-bold text-white font-outfit focus:outline-none focus:border-emerald-500/50 transition-colors">
                            @error('name') <p class="text-rose-500 text-[9px] mt-1">{{ $message }}</p> @enderror
                        </div>
                        <div>
                            <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block mb-3 px-1">Email Terminal</label>
                            <input type="email" name="email" id="email-input" value="{{ old('email', Auth::user()->email) }}" class="w-full bg-black border border-white/5 rounded-2xl px-6 py-4 text-sm font-bold text-white font-outfit focus:outline-none focus:border-emerald-500/50 transition-colors">
                            @error('email') <p class="text-rose-500 text-[9px] mt-1">{{ $message }}</p> @enderror
                        </div>
                        <div class="sm:col-span-2">
                            <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block mb-3 px-1">Active Since</label>
                            <div class="bg-black/50 border border-white/5 rounded-2xl px-6 py-4 text-sm font-bold text-white/40 font-outfit italic">{{ Auth::user()->created_at->translatedFormat('d F Y (H:i)') }}</div>
                        </div>
                    </div>

                    <div class="mt-12 flex gap-4">
                        <button type="submit" class="px-10 py-5 bg-emerald-500 hover:bg-emerald-400 text-black rounded-2xl text-[10px] font-black uppercase tracking-[0.25em] shadow-2xl shadow-emerald-500/20 transition-all active:scale-[0.98]">
                            Update Profile
                        </button>
                        <button type="button" onclick="location.reload()" class="px-10 py-5 bg-white/5 border border-white/10 text-white/40 hover:bg-white/10 rounded-2xl text-[10px] font-black uppercase tracking-[0.25em] transition-all active:scale-[0.98]">
                            Reset Changes
                        </button>
                    </div>
                </form>

                {{-- Hidden Delete Photo Form --}}
                <form id="delete-photo-form" action="{{ route('profile.photo.delete') }}" method="POST" class="hidden">
                    @csrf
                    @method('DELETE')
                </form>
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
