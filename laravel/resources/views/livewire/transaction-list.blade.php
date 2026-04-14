{{-- resources/views/livewire/transaction-list.blade.php --}}
<div class="space-y-5">

    {{-- Flash --}}
    @if (session()->has('success'))
    <div class="bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3 text-sm font-medium">
        ✅ {{ session('success') }}
    </div>
    @endif

    {{-- Header + Actions --}}
    <div class="flex items-center justify-between">
        <h1 class="text-2xl font-bold text-gray-900">Catatan Transaksi</h1>
        <div class="flex gap-3">
            <a href="{{ route('transactions.export-pdf') }}"
                target="_blank"
                class="flex items-center gap-2 px-4 py-2 border border-gray-200 rounded-lg text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 transition">
                📄 Export PDF
            </a>
            <button wire:click="openModal()"
                class="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg text-sm font-semibold hover:bg-green-700 transition">
                + Tambah Transaksi
            </button>
        </div>
    </div>

    {{-- Filters --}}
    <div class="bg-white border border-gray-100 rounded-xl p-4 flex flex-wrap gap-3 items-end">
        <div>
            <label class="text-xs font-semibold text-gray-500 block mb-1">CARI</label>
            <input wire:model.live.debounce.300ms="search"
                class="border border-gray-200 rounded-lg px-3 py-2 text-sm w-48 outline-none focus:ring-2 focus:ring-green-500"
                placeholder="Cari judul...">
        </div>
        <div>
            <label class="text-xs font-semibold text-gray-500 block mb-1">TIPE</label>
            <select wire:model.live="type"
                class="border border-gray-200 rounded-lg px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-green-500">
                <option value="">Semua</option>
                <option value="income">Pemasukan</option>
                <option value="expense">Pengeluaran</option>
            </select>
        </div>
        <div>
            <label class="text-xs font-semibold text-gray-500 block mb-1">DARI</label>
            <input type="date" wire:model.live="fromDate"
                class="border border-gray-200 rounded-lg px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-green-500">
        </div>
        <div>
            <label class="text-xs font-semibold text-gray-500 block mb-1">SAMPAI</label>
            <input type="date" wire:model.live="toDate"
                class="border border-gray-200 rounded-lg px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-green-500">
        </div>
        <button wire:click="$set('search',''); $set('type',''); $set('fromDate',''); $set('toDate','')"
            class="px-3 py-2 text-sm text-gray-500 hover:text-gray-700">Reset</button>
    </div>

    {{-- Table --}}
    <div class="bg-white border border-gray-100 rounded-xl overflow-hidden">
        <table class="w-full text-sm">
            <thead>
                <tr class="bg-gray-50 text-left">
                    <th class="px-5 py-3 font-semibold text-gray-500 text-xs cursor-pointer"
                        wire:click="sortBy('date')">
                        Tanggal
                        @if($sortField==='date') {{ $sortOrder==='asc' ? '↑' : '↓' }} @endif
                    </th>
                    <th class="px-5 py-3 font-semibold text-gray-500 text-xs cursor-pointer"
                        wire:click="sortBy('title')">
                        Judul
                        @if($sortField==='title') {{ $sortOrder==='asc' ? '↑' : '↓' }} @endif
                    </th>
                    <th class="px-5 py-3 font-semibold text-gray-500 text-xs">Kategori</th>
                    <th class="px-5 py-3 font-semibold text-gray-500 text-xs">Tipe</th>
                    <th class="px-5 py-3 font-semibold text-gray-500 text-xs text-right cursor-pointer"
                        wire:click="sortBy('amount')">
                        Nominal
                        @if($sortField==='amount') {{ $sortOrder==='asc' ? '↑' : '↓' }} @endif
                    </th>
                    <th class="px-5 py-3 font-semibold text-gray-500 text-xs text-center">Aksi</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-50">
                @forelse($transactions as $tx)
                <tr class="hover:bg-gray-50 transition">
                    <td class="px-5 py-3.5 text-gray-500 text-xs">
                        {{ $tx->date->format('d M Y') }}
                    </td>
                    <td class="px-5 py-3.5 font-semibold text-gray-800">{{ $tx->title }}</td>
                    <td class="px-5 py-3.5 text-gray-500">
                        {{ $tx->category?->icon }} {{ $tx->category?->name ?? 'Umum' }}
                    </td>
                    <td class="px-5 py-3.5">
                        <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold
                            {{ $tx->type === 'income' ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-600' }}">
                            {{ $tx->type === 'income' ? 'Pemasukan' : 'Pengeluaran' }}
                        </span>
                    </td>
                    <td class="px-5 py-3.5 text-right font-bold
                        {{ $tx->type === 'income' ? 'text-green-600' : 'text-red-500' }}">
                        {{ $tx->type === 'income' ? '+' : '-' }}Rp {{ number_format($tx->amount, 0, ',', '.') }}
                    </td>
                    <td class="px-5 py-3.5 text-center">
                        <div class="flex items-center justify-center gap-1">
                            <button wire:click="openModal({{ $tx->id }})"
                                class="p-1.5 rounded-lg hover:bg-gray-100 text-gray-400 hover:text-gray-600 transition">
                                ✏️
                            </button>
                            <button wire:click="delete({{ $tx->id }})"
                                wire:confirm="Yakin hapus transaksi ini?"
                                class="p-1.5 rounded-lg hover:bg-red-50 text-gray-400 hover:text-red-500 transition">
                                🗑️
                            </button>
                        </div>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="6" class="px-5 py-16 text-center text-gray-400">
                        <p class="text-4xl mb-3">📭</p>
                        <p class="font-semibold text-gray-600">Belum ada transaksi</p>
                        <p class="text-sm mt-1">Klik "+ Tambah Transaksi" untuk mulai mencatat</p>
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>

        @if($transactions->hasPages())
        <div class="px-5 py-3 border-t border-gray-100">
            {{ $transactions->links() }}
        </div>
        @endif
    </div>
</div>

{{-- Modal --}}
@if($showModal)
<div class="fixed inset-0 bg-black/40 z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-7"
         x-data x-init="$el.scrollIntoView({behavior:'smooth'})">

        <h2 class="text-xl font-bold text-gray-900 mb-5">
            {{ $editingId ? 'Edit Transaksi' : 'Tambah Transaksi' }}
        </h2>

        {{-- Type Toggle --}}
        <div class="flex bg-gray-100 rounded-xl p-1 gap-1 mb-5">
            <button wire:click="$set('fType','expense')"
                class="flex-1 py-2.5 rounded-lg text-sm font-semibold transition
                    {{ $fType==='expense' ? 'bg-red-500 text-white shadow-sm' : 'text-gray-500' }}">
                ↑ Pengeluaran
            </button>
            <button wire:click="$set('fType','income')"
                class="flex-1 py-2.5 rounded-lg text-sm font-semibold transition
                    {{ $fType==='income' ? 'bg-green-600 text-white shadow-sm' : 'text-gray-500' }}">
                ↓ Pemasukan
            </button>
        </div>

        @error('fAmount') <p class="text-red-500 text-xs mb-2">{{ $message }}</p> @enderror
        @error('fTitle')  <p class="text-red-500 text-xs mb-2">{{ $message }}</p> @enderror

        <div class="space-y-4">
            <div>
                <label class="text-xs font-bold text-gray-500 mb-1 block">JUDUL TRANSAKSI</label>
                <input wire:model="fTitle"
                    class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-green-500 bg-gray-50"
                    placeholder="Contoh: Makan siang">
            </div>
            <div>
                <label class="text-xs font-bold text-gray-500 mb-1 block">NOMINAL (Rp)</label>
                <input type="number" wire:model="fAmount"
                    class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-green-500 bg-gray-50"
                    placeholder="50000">
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="text-xs font-bold text-gray-500 mb-1 block">KATEGORI</label>
                    <select wire:model="fCategoryId"
                        class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
                        <option value="0">Pilih kategori</option>
                        @foreach($categories as $cat)
                        <option value="{{ $cat->id }}">{{ $cat->icon }} {{ $cat->name }}</option>
                        @endforeach
                    </select>
                </div>
                <div>
                    <label class="text-xs font-bold text-gray-500 mb-1 block">TANGGAL</label>
                    <input type="date" wire:model="fDate"
                        class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
                </div>
            </div>
            <div>
                <label class="text-xs font-bold text-gray-500 mb-1 block">CATATAN (opsional)</label>
                <textarea wire:model="fNote" rows="2"
                    class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-green-500 bg-gray-50 resize-none"
                    placeholder="Catatan tambahan..."></textarea>
            </div>
        </div>

        <div class="flex gap-3 mt-6">
            <button wire:click="$set('showModal', false)"
                class="flex-1 px-4 py-2.5 border border-gray-200 rounded-xl text-sm font-semibold text-gray-700 hover:bg-gray-50 transition">
                Batal
            </button>
            <button wire:click="save()"
                class="flex-1 px-4 py-2.5 rounded-xl text-sm font-semibold text-white transition
                    {{ $fType==='income' ? 'bg-green-600 hover:bg-green-700' : 'bg-red-500 hover:bg-red-600' }}">
                <span wire:loading.remove wire:target="save">Simpan</span>
                <span wire:loading wire:target="save">Menyimpan...</span>
            </button>
        </div>
    </div>
</div>
@endif
