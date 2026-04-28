{{-- resources/views/livewire/admin/sidebar.blade.php --}}
<aside class="w-64 h-screen bg-[#0D0D0D] border-r border-white/5 flex flex-col fixed inset-y-0 left-0 z-50">
    {{-- Logo --}}
    <div class="flex items-center gap-3 px-8 py-10">
        <div class="w-10 h-10 bg-emerald-500 rounded-xl flex items-center justify-center text-black shadow-lg shadow-emerald-500/20">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
        </div>
        <span class="text-xl font-outfit font-extrabold tracking-tight text-white italic">Money<span class="text-emerald-500">Track</span></span>
    </div>

    {{-- Navigation --}}
    <nav class="flex-1 px-4 space-y-1.5 mt-2">
        <div class="px-5 text-[9px] font-black text-white/20 uppercase tracking-[0.3em] mb-4">Control Terminal</div>

        <a href="{{ route('admin.dashboard') }}"
            class="group flex items-center gap-3 px-4 py-4 rounded-2xl text-sm font-bold transition-all duration-300
                {{ request()->routeIs('admin.dashboard') ? 'bg-emerald-500 text-black shadow-lg shadow-emerald-500/20' : 'text-white/40 hover:text-white hover:bg-white/5' }}">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
            </svg>
            Dashboard
        </a>

        <a href="{{ route('admin.users') }}"
            class="group flex items-center gap-3 px-4 py-4 rounded-2xl text-sm font-bold transition-all duration-300
                {{ request()->routeIs('admin.users') ? 'bg-emerald-500 text-black shadow-lg shadow-emerald-500/20' : 'text-white/40 hover:text-white hover:bg-white/5' }}">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 {{ request()->routeIs('admin.users') ? 'opacity-100' : 'opacity-40 group-hover:opacity-100 transition-opacity' }}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
            User Control
        </a>

        <a href="{{ route('admin.categories') }}"
            class="group flex items-center gap-3 px-4 py-4 rounded-2xl text-sm font-bold transition-all duration-300
                {{ request()->routeIs('admin.categories') ? 'bg-emerald-500 text-black shadow-lg shadow-emerald-500/20' : 'text-white/40 hover:text-white hover:bg-white/5' }}">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 {{ request()->routeIs('admin.categories') ? 'opacity-100' : 'opacity-40 group-hover:opacity-100 transition-opacity' }}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
            </svg>
            System Categories
        </a>

        <a href="{{ route('admin.transactions') }}"
            class="group flex items-center gap-3 px-4 py-4 rounded-2xl text-sm font-bold transition-all duration-300
                {{ request()->routeIs('admin.transactions') ? 'bg-emerald-500 text-black shadow-lg shadow-emerald-500/20' : 'text-white/40 hover:text-white hover:bg-white/5' }}">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 {{ request()->routeIs('admin.transactions') ? 'opacity-100' : 'opacity-40 group-hover:opacity-100 transition-opacity' }}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
            </svg>
            Global Transactions
        </a>

        <a href="{{ route('admin.profile') }}"
            class="group flex items-center gap-3 px-4 py-4 rounded-2xl text-sm font-bold transition-all duration-300
                {{ request()->routeIs('admin.profile') ? 'bg-emerald-500 text-black shadow-lg shadow-emerald-500/20' : 'text-white/40 hover:text-white hover:bg-white/5' }}">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 {{ request()->routeIs('admin.profile') ? 'opacity-100' : 'opacity-40 group-hover:opacity-100 transition-opacity' }}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            Settings
        </a>
    </nav>

    {{-- Bottom Section --}}
    <div class="p-6 border-t border-white/5">
        <button wire:click="logout"
            class="group w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-sm font-bold text-rose-500 hover:bg-rose-500/10 transition-all duration-300">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
            Logout
        </button>
    </div>
</aside>


