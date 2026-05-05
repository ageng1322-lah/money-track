<div>
    @section('header_title', 'INFRASTRUCTURE LOGS')

    <div class="space-y-10 animate-in fade-in duration-700">

        {{-- Filters --}}
        <div class="bg-[#111111] rounded-[2.5rem] p-8 border border-white/[0.05] shadow-2xl space-y-6">
            <div class="flex flex-col md:flex-row gap-6">
                <div class="flex-1 relative flex items-center group">
                    <input wire:model.live.debounce.300ms="search"
                        class="w-full bg-black border border-white/[0.08] rounded-2xl pl-16 pr-8 py-5 text-base font-bold text-white outline-none focus:ring-4 focus:ring-emerald-500/10 focus:border-emerald-500/30 transition-all placeholder:text-white/10 p-2"
                        placeholder="Search identities or notes...">
                </div>
            </div>
        </div>

        {{-- Table --}}
        <div class="bg-[#111111] rounded-[2.5rem] border border-white/[0.05] shadow-2xl overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead>
                        <tr class="bg-white/[0.02] text-left">
                            <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em]">Auth Identity</th>
                            <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em]">Payload Note</th>
                            <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em]">Category</th>
                            <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em] text-right">Value Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-white/[0.03]">
                        @forelse ($transactions as $transaction)
                        <tr class="group hover:bg-white/[0.01] transition-all">
                            <td class="px-8 py-6">
                                <div class="flex items-center gap-5">
                                    <div class="w-12 h-12 rounded-xl bg-black border border-white/[0.05] flex items-center justify-center text-lg font-black text-emerald-500 shadow-inner group-hover:border-emerald-500/30 transition-all italic">
                                        {{ strtoupper(substr($transaction->user->name, 0, 1)) }}
                                    </div>
                                    <div>
                                        <p class="text-base font-black text-white tracking-tight italic uppercase group-hover:text-emerald-500 transition-colors leading-none mb-1">{{ $transaction->user->name }}</p>
                                        <p class="text-[9px] font-black text-white/20 uppercase tracking-widest italic">{{ $transaction->date->translatedFormat('d M Y') }}</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-8 py-6">
                                <div class="space-y-1">
                                    <p class="text-sm font-bold text-white/60 tracking-wide line-clamp-1 italic">— {{ $transaction->note ?? 'No Payload' }}</p>
                                    <p class="text-[8px] font-black text-white/20 uppercase tracking-[0.2em] italic">{{ $transaction->user->email }}</p>
                                </div>
                            </td>
                            <td class="px-8 py-6">
                                <div class="inline-flex items-center gap-3 px-5 py-2.5 bg-black rounded-xl border border-white/[0.05]">
                                    <span class="text-xl">{{ $transaction->category?->icon ?? '💰' }}</span>
                                    <span class="text-[10px] font-black text-white uppercase tracking-widest">{{ $transaction->category?->name ?? 'Unmapped' }}</span>
                                </div>
                            </td>
                            <td class="px-8 py-6 text-right">
                                <div class="flex items-center justify-end gap-5">
                                    <span class="text-xl font-black italic tracking-tighter {{ $transaction->type === 'expense' ? 'text-rose-500' : 'text-emerald-500' }}">
                                        {{ $transaction->type === 'expense' ? '-' : '+' }}Rp{{ number_format($transaction->amount, 0, ',', '.') }}
                                    </span>
                                </div>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="4" class="px-8 py-24 text-center">
                                <div class="flex flex-col items-center gap-4">
                                    <div class="w-16 h-16 rounded-3xl bg-white/[0.02] border border-white/[0.05] flex items-center justify-center text-white/10">
                                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path></svg>
                                    </div>
                                    <p class="text-[10px] font-black text-white/20 uppercase tracking-[0.4em] italic">No activity detected in database</p>
                                </div>
                            </td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>

            <div class="px-8 py-6 bg-black/20 border-t border-white/[0.03]">
                {{ $transactions->links() }}
            </div>
        </div>
    </div>
</div>
