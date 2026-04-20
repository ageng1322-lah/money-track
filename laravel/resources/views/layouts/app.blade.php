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
        :root {
            --bg-black: #000000;
            --bg-card: #111111;
            --bg-sidebar: #0D0D0D;
            --text-white: #ffffff;
            --text-muted: rgba(255, 255, 255, 0.4);
            --text-muted-darker: rgba(255, 255, 255, 0.2);
            --border: rgba(255, 255, 255, 0.05);
            --glass: rgba(255, 255, 255, 0.03);
        }

        .light-mode {
            --bg-black: #f8fafc;
            --bg-card: #ffffff;
            --bg-sidebar: #ffffff;
            --text-white: #0f172a;
            --text-muted: #1e293b;
            --text-muted-darker: #475569;
            --border: rgba(0, 0, 0, 0.08);
            --glass: rgba(0, 0, 0, 0.02);
        }

        body { font-family: 'Inter', sans-serif; background-color: var(--bg-black); color: var(--text-white); transition: background-color 0.3s, color 0.3s; }
        .font-outfit { font-family: 'Outfit', sans-serif; }
        .glass { background: var(--glass); backdrop-filter: blur(10px); }
        
        /* Overrides for hardcoded classes to support light mode */
        .light-mode .bg-\[\#111111\] { background-color: var(--bg-card) !important; border: 1px solid var(--border) !important; box-shadow: 0 10px 30px -10px rgba(0,0,0,0.05) !important; }
        .light-mode .bg-\[\#0D0D0D\] { background-color: var(--bg-sidebar) !important; border-right: 1px solid var(--border) !important; }
        .light-mode .bg-black { background-color: var(--bg-black) !important; }
        .light-mode .bg-black\/50 { background-color: rgba(0,0,0,0.02) !important; }
        .light-mode .bg-black\/80 { background-color: rgba(255,255,255,0.7) !important; }
        .light-mode .text-white { color: var(--text-white) !important; }
        .light-mode .text-white\/40 { color: var(--text-muted) !important; }
        .light-mode .text-white\/20 { color: var(--text-muted-darker) !important; opacity: 1; }
        .light-mode .text-white\/60 { color: var(--text-muted) !important; }
        .light-mode .border-white\/5 { border-color: var(--border) !important; }
        .light-mode .border-white\/10 { border-color: var(--border) !important; }
        .light-mode .divide-white\/\[0\.03\] > * { border-color: var(--border) !important; }
        .light-mode .bg-white\/5 { background-color: var(--glass) !important; border: 1px solid var(--border) !important; }
        .light-mode .bg-white\/10 { background-color: rgba(0,0,0,0.05) !important; }
        .light-mode .bg-white\/\[0\.02\] { background-color: var(--glass) !important; border: 1px solid var(--border) !important; }
        .light-mode .hover\:bg-white\/\[0\.05\]:hover { background-color: rgba(0,0,0,0.03) !important; }
        .light-mode .hover\:bg-white\/10:hover { background-color: rgba(0,0,0,0.05) !important; }
        
        /* Sidebar active state fix when in light mode */
        .light-mode aside .text-white\/40 { color: var(--text-muted-darker) !important; }
        .light-mode aside .bg-emerald-500 { background-color: #10b981 !important; color: #ffffff !important; }
        .light-mode aside .bg-white\/5 { background-color: #f1f5f9 !important; border: none !important; }
    </style>
</head>
<body class="h-full antialiased overflow-x-hidden">
    <script>
        if (localStorage.getItem('theme') === 'light') {
            document.body.classList.add('light-mode');
        }
    </script>

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
                <button onclick="toggleTheme()" class="w-10 h-10 flex items-center justify-center rounded-2xl bg-white/5 text-white/40 hover:text-emerald-500 hover:bg-emerald-500/10 transition-all border border-white/5">
                    <svg id="theme-icon-sun" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v1m0 16v1m9-9h-1M4 9H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                    </svg>
                </button>
                <div class="flex items-center gap-3 pl-6 border-l border-white/10">
                    <div class="w-10 h-10 rounded-2xl bg-emerald-500 overflow-hidden flex items-center justify-center text-black font-black text-sm shadow-lg shadow-emerald-500/20">
                        @if(Auth::user()->photo_url)
                            <img src="{{ Auth::user()->photo_url }}" alt="{{ Auth::user()->name }}" class="w-full h-full object-cover">
                        @else
                            {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                        @endif
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
            <p class="text-[11px] text-slate-400 font-medium">© 2026 MoneyTrack Dashboard — Dibuat untuk Masa Depan Finansialmu</p>
        </footer>
    </main>
</div>

<script>
    function toggleTheme() {
        const body = document.body;
        body.classList.toggle('light-mode');
        const theme = body.classList.contains('light-mode') ? 'light' : 'dark';
        localStorage.setItem('theme', theme);
        
        // Dispatch event for other components (like charts)
        window.dispatchEvent(new CustomEvent('theme-changed', { detail: { theme } }));
    }
</script>

@livewireScripts
@stack('scripts')
</body>
</html>
