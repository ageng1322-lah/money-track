{{-- resources/views/layouts/app.blade.php --}}
<!DOCTYPE html>
<html lang="id" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ config('app.name', 'MoneyTrack') }} — Atur Keuanganmu</title>
    
    <!-- Google Fonts: Inter & Outfit -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap" rel="stylesheet">

    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @livewireStyles
    <style>
        body { font-family: 'Inter', sans-serif; }
        .font-outfit { font-family: 'Outfit', sans-serif; }
        .glass { background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); }
    </style>
</head>
<body class="h-full bg-black text-white antialiased overflow-x-hidden">

<div class="flex min-h-screen">
    {{-- Sidebar --}}
    @livewire('sidebar')

    {{-- Main Content --}}
    <main class="ml-64 flex-1 flex flex-col min-h-screen">
        {{-- Top Header --}}
        <header class="h-20 bg-black flex items-center justify-between px-10 sticky top-0 z-40">
            <div>
                <h2 class="text-2xl font-outfit font-extrabold tracking-tight text-white">{{ $title ?? 'Dashboard' }}</h2>
                <p class="text-white/40 text-[10px] font-bold uppercase tracking-widest mt-0.5">Selamat datang kembali, {{ Auth::user()->name }}!</p>
            </div>
            <div class="flex items-center gap-6">
                <button class="w-10 h-10 flex items-center justify-center rounded-2xl bg-white/5 text-white/40 hover:text-emerald-500 hover:bg-emerald-500/10 transition-all border border-white/5">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v1m0 16v1m9-9h-1M4 9H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                    </svg>
                </button>
                <div class="flex items-center gap-3 pl-6 border-l border-white/10">
                    <div class="w-10 h-10 rounded-2xl bg-emerald-500 flex items-center justify-center text-black font-black text-sm shadow-lg shadow-emerald-500/20">
                        {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                    </div>
                </div>
            </div>
        </header>

        {{-- Page Content --}}
        <div class="flex-1 px-10 py-6">
            {{ $slot }}
        </div>
        
        {{-- Footer --}}
        <footer class="px-8 py-6 text-center">
            <p class="text-[11px] text-slate-400 font-medium">© 2026 MoneyTrack Dashboard — Dibuat dengan ❤️ untuk Masa Depan Finansialmu</p>
        </footer>
    </main>
</div>

@livewireScripts
@stack('scripts')
</body>
</html>
