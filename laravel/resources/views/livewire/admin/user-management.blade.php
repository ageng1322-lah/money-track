<div>
    @section('header_title', 'IDENTITY MANAGEMENT')

    <div class="space-y-10 animate-in fade-in duration-700">

        {{-- Filter Section --}}
        <div class="bg-[#111111] rounded-[2.5rem] p-8 border border-white/[0.05] shadow-2xl">
            <div class="relative flex items-center">
                <input wire:model.live.debounce.300ms="search"
                    class="w-full bg-black border border-white/[0.08] rounded-2xl pl-16 pr-8 py-5 text-base font-bold text-white outline-none focus:ring-4 focus:ring-emerald-500/10 focus:border-emerald-500/30 transition-all placeholder:text-white/10 p-2"
                    placeholder="Search users by name or email address...">
            </div>
        </div>

        {{-- Table --}}
        <div class="bg-[#111111] rounded-[2.5rem] border border-white/[0.05] shadow-2xl overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead>
                        <tr class="bg-white/[0.02] text-left">
                            <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em]">User Identity</th>
                            <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em]">Email Auth</th>
                            <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em]">Access Tier</th>
                            <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em]">Node Access</th>
                            <th class="px-8 py-6 text-[9px] font-black text-white/20 uppercase tracking-[0.4em] text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-white/[0.03]">
                        @foreach ($users as $user)
                        <tr class="group hover:bg-white/[0.01] transition-all">
                            <td class="px-8 py-6">
                                <div class="flex items-center gap-5">
                                    <div class="w-12 h-12 rounded-xl bg-black border border-white/[0.05] flex items-center justify-center text-lg font-black text-emerald-500 shadow-inner group-hover:border-emerald-500/30 transition-all italic">
                                        {{ strtoupper(substr($user->name, 0, 1)) }}
                                    </div>
                                    <span class="text-base font-black text-white tracking-tight italic uppercase group-hover:text-emerald-500 transition-colors">{{ $user->name }}</span>
                                </div>
                            </td>
                            <td class="px-8 py-6">
                                <span class="text-sm font-bold text-white/40 tracking-wide">{{ $user->email }}</span>
                            </td>
                            <td class="px-8 py-6">
                                <div class="flex items-center">
                                    <select wire:change="updateRole({{ $user->id }}, $event.target.value)" 
                                        class="bg-black border border-white/[0.1] rounded-xl px-5 py-2.5 text-[10px] font-black uppercase tracking-[0.1em] text-emerald-500 outline-none focus:ring-4 focus:ring-emerald-500/20 transition-all cursor-pointer hover:border-emerald-500/50"
                                        {{ $user->id === auth()->id() ? 'disabled' : '' }}>
                                        <option value="user" {{ $user->role === 'user' ? 'selected' : '' }}>Regular Member</option>
                                        <option value="admin" {{ $user->role === 'admin' ? 'selected' : '' }}>System Admin</option>
                                    </select>
                                </div>
                            </td>
                            <td class="px-8 py-6">
                                <p class="text-[9px] font-black text-white/20 uppercase tracking-[0.2em] italic">{{ $user->created_at->translatedFormat('d M Y') }}</p>
                            </td>
                            <td class="px-8 py-6">
                                <div class="flex items-center justify-center">
                                    @if($user->id !== auth()->id())
                                        <button wire:click="deleteUser({{ $user->id }})" wire:confirm="Purge this user from database? This action is irreversible."
                                            class="w-10 h-10 flex items-center justify-center rounded-xl bg-black border border-white/[0.05] text-white/10 hover:text-rose-500 hover:bg-rose-500/10 hover:border-rose-500/20 transition-all transform group-hover:scale-105 active:scale-95">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                            </svg>
                                        </button>
                                    @else
                                        <span class="text-[8px] font-black text-emerald-500 uppercase tracking-[0.3em] bg-emerald-500/5 px-4 py-2 rounded-full border border-emerald-500/10 italic">Primary Session</span>
                                    @endif
                                </div>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>

            <div class="px-8 py-6 bg-black/20 border-t border-white/[0.03]">
                {{ $users->links() }}
            </div>
        </div>
    </div>
</div>

