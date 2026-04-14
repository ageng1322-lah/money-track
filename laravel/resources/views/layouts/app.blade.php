{{-- resources/views/layouts/app.blade.php --}}
<!DOCTYPE html>
<html lang="id" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ config('app.name', 'FinTrack') }}</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @livewireStyles
</head>
<body class="h-full bg-gray-50 font-sans antialiased">

<div class="flex h-full">
    {{-- Sidebar --}}
    <aside class="w-60 bg-white border-r border-gray-100 flex flex-col fixed inset-y-0 left-0 z-10">
        {{-- Logo --}}
        <div class="flex items-center gap-3 px-5 py-6 border-b border-gray-100">
            <div class="w-9 h-9 bg-green-600 rounded-xl flex items-center justify-center text-white font-extrabold text-lg">₿</div>
            <span class="text-lg font-extrabold text-gray-900">FinTrack</span>
        </div>

        {{-- Nav --}}
        <nav class="flex-1 px-3 py-4 space-y-1">
            <a href="{{ route('dashboard') }}"
                class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition
                    {{ request()->routeIs('dashboard') ? 'bg-green-50 text-green-700' : 'text-gray-600 hover:bg-gray-50' }}">
                <span class="text-base">🏠</span> Dashboard
            </a>
            <a href="{{ route('transactions') }}"
                class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition
                    {{ request()->routeIs('transactions*') ? 'bg-green-50 text-green-700' : 'text-gray-600 hover:bg-gray-50' }}">
                <span class="text-base">📋</span> Catatan
            </a>
            <a href="{{ route('profile') }}"
                class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition
                    {{ request()->routeIs('profile') ? 'bg-green-50 text-green-700' : 'text-gray-600 hover:bg-gray-50' }}">
                <span class="text-base">👤</span> Profil
            </a>
        </nav>

        {{-- User --}}
        <div class="px-3 py-4 border-t border-gray-100">
            <div class="flex items-center gap-3 px-3 py-2 rounded-xl hover:bg-gray-50 cursor-pointer">
                <div class="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center text-green-700 font-bold text-sm flex-shrink-0">
                    {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                </div>
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-semibold text-gray-800 truncate">{{ Auth::user()->name }}</p>
                    <p class="text-xs text-gray-400 truncate">{{ Auth::user()->email }}</p>
                </div>
            </div>
            <form method="POST" action="{{ route('logout') }}" class="mt-1">
                @csrf
                <button type="submit"
                    class="w-full flex items-center gap-3 px-3 py-2 rounded-xl text-sm text-red-500 hover:bg-red-50 transition">
                    🚪 Keluar
                </button>
            </form>
        </div>
    </aside>

    {{-- Main --}}
    <main class="ml-60 flex-1 flex flex-col min-h-screen">
        <div class="flex-1 p-8">
            {{ $slot }}
        </div>
    </main>
</div>

@livewireScripts
@stack('scripts')
</body>
</html>
