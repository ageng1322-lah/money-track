{{-- resources/views/livewire/category-list.blade.php --}}
<div class="space-y-6">
    <div class="flex items-center justify-between">
        <div>
        </div>
        <button wire:click="openModal()"
                class="flex items-center gap-2 px-8 py-4 bg-emerald-500 text-black rounded-2xl text-[10px] font-black uppercase tracking-widest shadow-lg shadow-emerald-500/20 hover:bg-emerald-400 transition-all duration-300 transform active:scale-[0.98]">
                New Category
            </button>
    </div>
    <br>
    {{-- Flash Messages --}}
    @if (session()->has('success'))
        <div class="p-4 bg-emerald-500/10 border border-emerald-500/20 text-emerald-500 rounded-2xl text-sm">
            {{ session('success') }}
        </div>
    @endif
    @if (session()->has('error'))
        <div class="p-4 bg-rose-500/10 border border-rose-500/20 text-rose-500 rounded-2xl text-sm">
            {{ session('error') }}
        </div>
    @endif

    {{-- Grid Kategori --}}
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        @foreach($categories as $cat)
            <div class="group relative bg-[#111111] border border-white/5 p-6 rounded-3xl hover:border-emerald-500/30 transition-all duration-500">
                <div class="flex items-start justify-between">
                    <div class="flex items-center gap-4">
                        <div class="w-14 h-14 rounded-2xl flex items-center justify-center text-2xl shadow-inner transition-transform group-hover:scale-110 duration-500" 
                             style="background-color: {{ $cat->color }}20; color: {{ $cat->color }}; border: 1px solid {{ $cat->color }}30;">
                            {{ $cat->icon }}
                        </div>
                        <div>
                            <h4 class="font-bold text-white group-hover:text-emerald-400 transition-colors">{{ $cat->name }}</h4>
                            <div class="flex items-center gap-2 mt-1">
                                <span class="px-2 py-0.5 rounded-lg text-[9px] font-black uppercase tracking-wider
                                    {{ $cat->type === 'income' ? 'bg-emerald-500/10 text-emerald-500' : 'bg-rose-500/10 text-rose-500' }}">
                                    {{ $cat->type }}
                                </span>
                                @if($cat->is_default)
                                    <span class="text-[9px] font-bold text-white/20 uppercase tracking-tighter italic">Standard</span>
                                @endif
                            </div>
                        </div>
                    </div>
                    
                    @if(!$cat->is_default)
                    <div class="flex flex-col gap-2">
                        <button wire:click="openModal({{ $cat->id }})" class="p-2 hover:bg-white/5 rounded-xl text-white/40 hover:text-white transition-all">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                            </svg>
                        </button>
                        <button onclick="confirm('Hapus kategori ini?') || event.stopImmediatePropagation()" wire:click="delete({{ $cat->id }})" class="p-2 hover:bg-rose-500/10 rounded-xl text-white/40 hover:text-rose-500 transition-all">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                            </svg>
                        </button>
                    </div>
                    @endif
                </div>
            </div>
        @endforeach
    </div>

    {{-- Modal Form --}}
    @if($showModal)
    <div class="fixed inset-0 z-[60] flex items-center justify-center p-6 bg-black/80 backdrop-blur-sm">
        <div class="bg-[#111111] w-full max-w-lg rounded-[2.5rem] border border-white/10 shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-300">
            <div class="p-8">
                <div class="flex items-center justify-between mb-8">
                    <h3 class="text-xl font-black text-white italic tracking-tight">{{ $editingId ? 'Edit Kategori' : 'Kategori Baru' }}</h3>
                    <button wire:click="$set('showModal', false)" class="w-10 h-10 flex items-center justify-center rounded-2xl bg-white/5 text-white/40 hover:text-white hover:bg-white/10 transition-all">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                    </button>
                </div>

                <form wire:submit.prevent="save" class="space-y-6">
                    <div>
                        <label class="block text-[10px] font-black text-white/40 uppercase tracking-[0.2em] mb-3 ml-1">Nama Kategori</label>
                        <input type="text" wire:model="fName" class="w-full bg-white/5 border border-white/5 rounded-2xl px-5 py-4 text-white placeholder-white/10 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500/50 transition-all">
                        @error('fName') <span class="text-rose-500 text-[10px] mt-1 ml-1">{{ $message }}</span> @enderror
                    </div>
                    <br>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-[10px] font-black text-white/40 uppercase tracking-[0.2em] mb-3 ml-1">Icon (Emoji)</label>
                            <input type="text" wire:model="fIcon" class="w-full bg-white/5 border border-white/5 rounded-2xl px-5 py-4 text-white text-center text-xl transition-all">
                        </div>
                        <div>
                            <label class="block text-[10px] font-black text-white/40 uppercase tracking-[0.2em] mb-3 ml-1">Warna</label>
                            <div class="flex items-center gap-3">
                                <input type="color" wire:model="fColor" class="w-14 h-14 bg-transparent border-none p-0 cursor-pointer rounded-xl">
                                <input type="text" wire:model="fColor" class="flex-1 bg-white/5 border border-white/5 rounded-2xl px-4 py-4 text-white text-xs font-mono uppercase">
                            </div>
                        </div>
                    </div>
                    <br>
                    <div>
                        <label class="block text-[10px] font-black text-white/40 uppercase tracking-[0.2em] mb-3 ml-1">Tipe</label>
                        <div class="flex gap-2 p-1.5 bg-white/5 rounded-2xl">
                            @foreach(['expense' => 'Expense', 'income' => 'Income'] as $val => $label)
                                <button type="button" wire:click="$set('fType', '{{ $val }}')" class="flex-1 py-3 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all duration-300 {{ $fType === $val ? 'bg-emerald-500 text-black shadow-lg shadow-emerald-500/20' : 'text-white/20 hover:text-white/40' }}">
                                    {{ $label }}
                                </button>
                            @endforeach
                        </div>
                    </div>
                    <br>
                    <div class="pt-4 flex gap-3">
                        <button type="button" wire:click="$set('showModal', false)" class="flex-1 py-4 rounded-2xl bg-white/5 text-white/60 text-[11px] font-black uppercase tracking-widest hover:bg-white/10 transition-all">Batal</button>
                        <button type="submit" class="flex-[2] py-4 rounded-2xl bg-emerald-500 text-black text-[11px] font-black uppercase tracking-widest hover:bg-emerald-600 transition-all shadow-lg shadow-emerald-500/20">Simpan Kategori</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    @endif
</div>
