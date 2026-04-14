{{-- resources/views/livewire/transaction-list.blade.php --}}
<div class="space-y-10 animate-in fade-in duration-700">
    <x-slot name="title">Recording</x-slot>

    {{-- Toast Notification --}}
    @if (session()->has('success'))
    <div x-data="{ show: true }" x-show="show" x-init="setTimeout(() => show = false, 3000)"
        class="fixed bottom-8 right-8 z-[100] bg-emerald-500 text-black rounded-2xl shadow-2xl px-6 py-4 flex items-center gap-4 border border-emerald-400 animate-in slide-in-from-right duration-500">
        <div class="w-8 h-8 bg-black/20 rounded-lg flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
            </svg>
        </div>
        <p class="text-sm font-black tracking-tight uppercase">{{ session('success') }}</p>
    </div>
    @endif

    {{-- Page Header --}}
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div>
            <h1 class="text-3xl font-outfit font-extrabold text-white tracking-tight italic">Transaction History</h1>
            <p class="text-white/40 font-bold uppercase tracking-widest text-[10px] mt-2">Detail penuangan arus kas pribadimu.</p>
        </div>
        <div class="flex items-center gap-3">
            <a href="{{ route('transactions.export-pdf') }}" target="_blank"
                class="group flex items-center gap-2 px-6 py-4 bg-white/5 border border-white/10 rounded-2xl text-[10px] font-black uppercase tracking-widest text-white/60 hover:text-rose-500 hover:bg-white/10 transition-all duration-300 shadow-sm">
                PDF Export
            </a>
            <button wire:click="openModal()"
                class="flex items-center gap-2 px-8 py-4 bg-emerald-500 text-black rounded-2xl text-[10px] font-black uppercase tracking-widest shadow-lg shadow-emerald-500/20 hover:bg-emerald-400 transition-all duration-300 transform active:scale-[0.98]">
                New Transaction
            </button>
        </div>
    </div>

    {{-- Filters Card --}}
    <div class="bg-[#111111] rounded-[2.5rem] p-8 border border-white/5 shadow-2xl flex flex-wrap items-end gap-6">
        <div class="flex-1 min-w-[200px]">
            <label class="text-[10px] font-black text-white/20 uppercase tracking-[0.2em] block mb-3 px-1">Cari transaksi</label>
            <input wire:model.live.debounce.300ms="search"
                class="w-full bg-black border border-white/5 rounded-2xl px-6 py-4 text-sm font-bold text-white outline-none focus:ring-2 focus:ring-emerald-500 transition-all"
                placeholder="Search description...">
        </div>
        <div class="w-48">
            <label class="text-[10px] font-black text-white/20 uppercase tracking-[0.2em] block mb-3 px-1">Jenis</label>
            <select wire:model.live="type"
                class="w-full bg-black border border-white/5 rounded-2xl px-6 py-4 text-sm font-bold text-white/60 outline-none focus:ring-2 focus:ring-emerald-500 transition-all cursor-pointer">
                <option value="">Semua Tipe</option>
                <option value="income">Pemasukan</option>
                <option value="expense">Pengeluaran</option>
            </select>
        </div>
        <div class="flex gap-4">
            <div class="w-44">
                <label class="text-[10px] font-black text-white/20 uppercase tracking-[0.2em] block mb-3 px-1">Dari</label>
                <input type="date" wire:model.live="fromDate"
                    class="w-full bg-black border border-white/5 rounded-2xl px-6 py-4 text-sm font-bold text-white/60 outline-none focus:ring-2 focus:ring-emerald-500 transition-all cursor-pointer">
            </div>
            <div class="w-44">
                <label class="text-[10px] font-black text-white/20 uppercase tracking-[0.2em] block mb-3 px-1">Hingga</label>
                <input type="date" wire:model.live="toDate"
                    class="w-full bg-black border border-white/5 rounded-2xl px-6 py-4 text-sm font-bold text-white/60 outline-none focus:ring-2 focus:ring-emerald-500 transition-all cursor-pointer">
            </div>
        </div>
        <button wire:click="$set('search',''); $set('type',''); $set('fromDate',''); $set('toDate','')"
            class="h-14 px-6 text-[10px] font-black text-white/20 hover:text-rose-500 uppercase tracking-widest transition-colors">
            Reset
        </button>
    </div>

    {{-- Transactions Table --}}
    <div class="bg-[#111111] rounded-[2.5rem] border border-white/5 shadow-2xl overflow-hidden relative">
        <table class="w-full">
            <thead>
                <tr class="bg-black/50 text-left">
                    <th class="px-10 py-6 text-[10px] font-black text-white/20 uppercase tracking-[0.2em] cursor-pointer group" wire:click="sortBy('date')">
                        Tanggal @if($sortField==='date') {{ $sortOrder==='asc' ? '↑' : '↓' }} @endif
                    </th>
                    <th class="px-10 py-6 text-[10px] font-black text-white/20 uppercase tracking-[0.2em] cursor-pointer group" wire:click="sortBy('title')">
                        Deskripsi @if($sortField==='title') {{ $sortOrder==='asc' ? '↑' : '↓' }} @endif
                    </th>
                    <th class="px-10 py-6 text-[10px] font-black text-white/20 uppercase tracking-[0.2em]">Kategori</th>
                    <th class="px-10 py-6 text-[10px] font-black text-white/20 uppercase tracking-[0.2em] text-right cursor-pointer group" wire:click="sortBy('amount')">
                        Nominal @if($sortField==='amount') {{ $sortOrder==='asc' ? '↑' : '↓' }} @endif
                    </th>
                    <th class="px-10 py-6 text-[10px] font-black text-white/20 uppercase tracking-[0.2em] text-center">Aksi</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-white/[0.03]">
                @forelse($transactions as $tx)
                <tr class="group hover:bg-white/[0.02] transition-all duration-300">
                    <td class="px-10 py-6">
                        <p class="text-[11px] font-black text-white/40 uppercase tracking-widest">{{ $tx->date->translatedFormat('d M Y') }}</p>
                    </td>
                    <td class="px-10 py-6">
                        <p class="text-sm font-bold text-white group-hover:text-emerald-500 transition-colors">{{ $tx->title }}</p>
                        @if($tx->note)
                            <p class="text-[10px] text-white/20 font-medium mt-1 truncate max-w-xs italic">— {{ $tx->note }}</p>
                        @endif
                    </td>
                    <td class="px-10 py-6">
                        <div class="inline-flex items-center gap-3 px-4 py-2 rounded-xl bg-black border border-white/5">
                            <span class="text-base">{{ $tx->category?->icon ?? '💰' }}</span>
                            <span class="text-[10px] font-black text-white/40 uppercase tracking-widest">{{ $tx->category?->name ?? 'Umum' }}</span>
                        </div>
                    </td>
                    <td class="px-10 py-6 text-right">
                        <p class="text-sm font-black {{ $tx->type === 'income' ? 'text-emerald-500' : 'text-rose-500' }}">
                            {{ $tx->type === 'income' ? '+' : '-' }}Rp{{ number_format($tx->amount, 0, ',', '.') }}
                        </p>
                    </td>
                    <td class="px-10 py-6">
                        <div class="flex items-center justify-center gap-3">
                            <button wire:click="openModal({{ $tx->id }})"
                                class="w-10 h-10 flex items-center justify-center rounded-xl bg-black border border-white/5 text-white/20 hover:text-emerald-500 hover:border-emerald-500/50 transition-all duration-300 shadow-sm">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                </svg>
                            </button>
                            <button wire:click="delete({{ $tx->id }})" wire:confirm="Delete this record permanently?"
                                class="w-10 h-10 flex items-center justify-center rounded-xl bg-black border border-white/5 text-white/20 hover:text-rose-500 hover:border-rose-500/50 transition-all duration-300 shadow-sm">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                </svg>
                            </button>
                        </div>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="5" class="px-10 py-32 text-center">
                        <div class="flex flex-col items-center">
                            <div class="w-24 h-24 bg-black rounded-full flex items-center justify-center text-5xl mb-8 opacity-20 italic">Empty</div>
                            <h5 class="text-xl font-outfit font-black text-white italic">No records found</h5>
                            <button wire:click="openModal()" class="mt-8 text-[10px] font-black text-emerald-500 uppercase tracking-[0.3em] hover:text-emerald-400 transition">Create First Entry &rarr;</button>
                        </div>
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>

        @if($transactions->hasPages())
        <div class="px-10 py-8 bg-black/50 border-t border-white/[0.03]">
            {{ $transactions->links() }}
        </div>
        @endif
    </div>

    {{-- Transaction Modal --}}
    @if($showModal)
    <div class="fixed inset-0 z-[100] flex items-center justify-center p-4 animate-in fade-in duration-300">
        <div class="fixed inset-0 bg-black/80 backdrop-blur-md" wire:click="$set('showModal', false)"></div>

        <div class="relative bg-[#111111] rounded-[3rem] shadow-2xl w-full max-w-lg overflow-hidden border border-white/10 animate-in zoom-in-95 duration-300">
            <div class="p-10">
                <div class="flex items-center justify-between mb-10">
                    <div>
                        <h2 class="text-3xl font-outfit font-extrabold text-white tracking-tight italic">
                            {{ $editingId ? 'Edit Entry' : 'Manual Entry' }}
                        </h2>
                        <p class="text-[10px] font-black text-white/20 uppercase tracking-[0.25em] mt-2">Personal transaction manager</p>
                    </div>
                    <button wire:click="$set('showModal', false)" class="w-12 h-12 rounded-2xl bg-white/5 hover:bg-white/10 flex items-center justify-center transition-colors">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white/20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                <div class="flex bg-black rounded-2xl p-2 gap-3 mb-10 border border-white/5 shadow-inner">
                    <button wire:click="$set('fType','expense')"
                        class="flex-1 py-4 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all duration-300
                            {{ $fType==='expense' ? 'bg-rose-500 text-black shadow-lg shadow-rose-500/20' : 'text-white/20 hover:text-white/40' }}">
                        Debit
                    </button>
                    <button wire:click="$set('fType','income')"
                        class="flex-1 py-4 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all duration-300
                            {{ $fType==='income' ? 'bg-emerald-500 text-black shadow-lg shadow-emerald-500/20' : 'text-white/20 hover:text-white/40' }}">
                        Credit
                    </button>
                </div>

                <div class="space-y-8">
                    <div>
                        <label class="text-[10px] font-black text-white/20 uppercase tracking-[0.2em] block mb-3 px-1">Description</label>
                        <input wire:model="fTitle"
                            class="w-full bg-black border border-white/10 rounded-2xl px-6 py-4 text-sm font-bold text-white outline-none focus:ring-2 focus:ring-emerald-500 transition-all font-outfit"
                            placeholder="What's this for?">
                    </div>

                    <div>
                        <label class="text-[10px] font-black text-white/20 uppercase tracking-[0.2em] block mb-3 px-1">Amount (IDR)</label>
                        <input type="number" wire:model="fAmount"
                            class="w-full bg-black border border-white/10 rounded-2xl px-6 py-4 text-4xl font-black text-white outline-none focus:ring-2 focus:ring-emerald-500 transition-all font-outfit placeholder:text-white/5"
                            placeholder="0">
                    </div>

                    <div class="grid grid-cols-2 gap-6">
                        <div>
                            <label class="text-[10px] font-black text-white/20 uppercase tracking-[0.2em] block mb-3 px-1">Category</label>
                            <select wire:model="fCategoryId"
                                class="w-full bg-black border border-white/10 rounded-2xl px-6 py-4 text-sm font-bold text-white/60 outline-none focus:ring-2 focus:ring-emerald-500 transition-all cursor-pointer">
                                <option value="0">General</option>
                                @foreach($categories as $cat)
                                <option value="{{ $cat->id }}">{{ $cat->icon }} {{ $cat->name }}</option>
                                @endforeach
                            </select>
                        </div>
                        <div>
                            <label class="text-[10px] font-black text-white/20 uppercase tracking-[0.2em] block mb-3 px-1">Date</label>
                            <input type="date" wire:model="fDate"
                                class="w-full bg-black border border-white/10 rounded-2xl px-6 py-4 text-sm font-bold text-white/60 outline-none focus:ring-2 focus:ring-emerald-500 transition-all cursor-pointer font-outfit">
                        </div>
                    </div>
                </div>

                <div class="mt-12 flex gap-4">
                    <button wire:click="save()"
                        class="flex-1 py-5 bg-emerald-500 hover:bg-emerald-400 text-black rounded-2xl text-[10px] font-black uppercase tracking-[0.2em] shadow-2xl shadow-emerald-500/20 transition-all active:scale-[0.98]">
                        Confirm Transaction
                    </button>
                </div>
            </div>
        </div>
    </div>
    @endif
</div>
