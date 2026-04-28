<div>
    @section('header_title', 'SYSTEM CATEGORIES')

    <div class="space-y-10 animate-in fade-in duration-700">
        {{-- Flash Message --}}
        @if (session()->has('message'))
            <div class="p-6 bg-emerald-500/10 border border-emerald-500/20 rounded-2xl flex items-center gap-4 animate-in zoom-in-95">
                <div class="w-10 h-10 rounded-xl bg-emerald-500 flex items-center justify-center text-black shadow-lg">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="3.5"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"></path></svg>
                </div>
                <p class="text-[10px] font-black text-emerald-500 uppercase tracking-widest italic">{{ session('message') }}</p>
            </div>
        @endif

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
            {{-- Form Column --}}
            <div class="space-y-8">
                <div class="bg-[#111111] rounded-[2.5rem] p-8 border border-white/[0.05] shadow-2xl relative overflow-hidden group">
                    <div class="absolute top-0 right-0 w-32 h-32 bg-emerald-500/5 rounded-full blur-3xl -mr-16 -mt-16 group-hover:bg-emerald-500/10 transition-colors"></div>
                    
                    <div class="flex items-center gap-4 mb-10 relative z-10">
                        <div class="w-10 h-10 rounded-xl bg-emerald-500/10 flex items-center justify-center text-emerald-500 border border-emerald-500/20">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"></path></svg>
                        </div>
                        <h2 class="text-lg font-outfit font-black text-white italic uppercase tracking-tight">{{ $is_editing ? 'Edit Protocol' : 'New Category' }}</h2>
                    </div>

                    <form wire:submit.prevent="{{ $is_editing ? 'update' : 'create' }}" class="space-y-6 relative z-10">
                        <div class="space-y-2 mb-4">
                            <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block px-1">Label</label>
                            <input type="text" wire:model="name" placeholder="e.g. Salary, Food..."
                                class="w-full bg-black border border-white/[0.08] rounded-xl px-6 py-4 text-sm font-bold text-white outline-none focus:ring-4 focus:ring-emerald-500/10 focus:border-emerald-500/30 transition-all placeholder:text-white/10">
                            @error('name') <span class="text-rose-500 text-[8px] font-black uppercase mt-1 block px-1 italic">{{ $message }}</span> @enderror
                        </div>

                        <div class="grid grid-cols-2 gap-6 mb-4">
                            <div class="space-y-2">
                                <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block px-1">Icon</label>
                                <input type="text" wire:model="icon" placeholder="Emoji"
                                    class="w-full bg-black border border-white/[0.08] rounded-xl px-6 py-4 text-center text-xl font-bold text-white outline-none focus:ring-4 focus:ring-emerald-500/10 focus:border-emerald-500/30 transition-all">
                                @error('icon') <span class="text-rose-500 text-[8px] font-black uppercase mt-1 block px-1 italic">{{ $message }}</span> @enderror
                            </div>
                            <div class="space-y-2">
                                <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block px-1">Color HEX</label>
                                <div class="relative">
                                    <input type="text" wire:model="color"
                                        class="w-full bg-black border border-white/[0.08] rounded-xl pl-12 pr-6 py-4 text-sm font-bold text-white outline-none focus:ring-4 focus:ring-emerald-500/10 focus:border-emerald-500/30 transition-all uppercase">
                                    <div class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 rounded-md border border-white/10" style="background-color: {{ $color }}"></div>
                                </div>
                                @error('color') <span class="text-rose-500 text-[8px] font-black uppercase mt-1 block px-1 italic">{{ $message }}</span> @enderror
                            </div>
                        </div>

                        <div class="space-y-2">
                            <label class="text-[9px] font-black text-white/20 uppercase tracking-[0.3em] block px-1">Protocol Type</label>
                            <div class="grid grid-cols-2 gap-4">
                                <button type="button" wire:click="$set('type', 'expense')" 
                                    class="py-4 rounded-xl text-[10px] font-black uppercase tracking-widest border transition-all {{ $type === 'expense' ? 'bg-rose-500/20 border-rose-500/50 text-rose-500 shadow-lg shadow-rose-500/10 italic' : 'bg-black border-white/5 text-white/20 hover:text-white' }}">
                                    Expense
                                </button>
                                <button type="button" wire:click="$set('type', 'income')" 
                                    class="py-4 rounded-xl text-[10px] font-black uppercase tracking-widest border transition-all {{ $type === 'income' ? 'bg-emerald-500/20 border-emerald-500/50 text-emerald-500 shadow-lg shadow-emerald-500/10 italic' : 'bg-black border-white/5 text-white/20 hover:text-white' }}">
                                    Income
                                </button>
                            </div>
                        </div>

                        <div class="pt-4 flex gap-4">
                            @if($is_editing)
                                <button type="button" wire:click="resetFields" class="flex-1 py-5 bg-white/5 border border-white/10 text-white/40 hover:text-white hover:bg-white/10 rounded-xl text-[10px] font-black uppercase tracking-[0.3em] transition-all">Cancel</button>
                            @endif
                            <button type="submit" class="flex-[2] py-5 bg-emerald-500 text-black rounded-xl text-[10px] font-black uppercase tracking-[0.3em] shadow-xl shadow-emerald-500/10 hover:bg-emerald-400 active:scale-[0.98] transition-all italic p-3">
                                {{ $is_editing ? 'update Data' : 'Add Category' }}
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            {{-- Table Column --}}
            <div class="lg:col-span-2 space-y-8">
                <div class="bg-[#111111] rounded-[2.5rem] p-8 border border-white/[0.05] shadow-2xl space-y-8">
                    <div class="relative flex items-center group">
                        <input wire:model.live.debounce.300ms="search"
                            class="w-full bg-black border border-white/[0.08] rounded-2xl pl-16 pr-8 py-5 text-base font-bold text-white outline-none focus:ring-4 focus:ring-emerald-500/10 focus:border-emerald-500/30 transition-all placeholder:text-white/10 p-5"
                            placeholder="Filter system categories...">
                    </div>

                    <div class="overflow-x-auto rounded-2xl border border-white/[0.03]">
                        <table class="w-full">
                            <thead>
                                <tr class="bg-white/[0.02] text-left">
                                    <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em]">Visual Payload</th>
                                    <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em]">Protocol Type</th>
                                    <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em] text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-white/[0.03]">
                                @forelse ($categories as $category)
                                <tr class="group hover:bg-white/[0.01] transition-all">
                                    <td class="px-8 py-6">
                                        <div class="flex items-center gap-5">
                                            <div class="w-12 h-12 rounded-xl bg-black border border-white/[0.05] flex items-center justify-center text-2xl shadow-inner group-hover:scale-110 transition-transform">
                                                {{ $category->icon }}
                                            </div>
                                            <div>
                                                <p class="text-base font-black text-white tracking-tight italic uppercase group-hover:text-emerald-500 transition-colors">{{ $category->name }}</p>
                                                <p class="text-[8px] font-black text-white/20 uppercase tracking-widest">{{ $category->color }}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <span class="px-4 py-2 rounded-lg text-[9px] font-black uppercase tracking-widest italic {{ $category->type === 'expense' ? 'bg-rose-500/10 text-rose-500 border border-rose-500/10' : 'bg-emerald-500/10 text-emerald-500 border border-emerald-500/10' }}">
                                            {{ $category->type }}
                                        </span>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="flex items-center justify-center gap-3">
                                            <button wire:click="edit({{ $category->id }})"
                                                class="w-10 h-10 flex items-center justify-center rounded-xl bg-black border border-white/[0.05] text-white/10 hover:text-emerald-500 hover:bg-emerald-500/10 hover:border-emerald-500/20 transition-all transform group-hover:scale-105 active:scale-95">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path></svg>
                                            </button>
                                            <button wire:click="delete({{ $category->id }})" wire:confirm="Purge this system category?"
                                                class="w-10 h-10 flex items-center justify-center rounded-xl bg-black border border-white/[0.05] text-white/10 hover:text-rose-500 hover:bg-rose-500/10 hover:border-rose-500/20 transition-all transform group-hover:scale-105 active:scale-95">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                @empty
                                <tr>
                                    <td colspan="3" class="px-8 py-24 text-center">
                                        <p class="text-[10px] font-black text-white/20 uppercase tracking-[0.4em] italic">No system categories defined</p>
                                    </td>
                                </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                    <div class="px-4 py-4">
                        {{ $categories->links() }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
