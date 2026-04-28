<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'Laravel') }} - Admin Platform</title>

    <!-- Fonts: Standardizing to Outfit and Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@100..900&family=Outfit:wght@100..900&display=swap" rel="stylesheet">

    <!-- Scripts -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @livewireStyles

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #000000;
            color: #ffffff;
            -webkit-font-smoothing: antialiased;
        }
        .font-outfit { font-family: 'Outfit', sans-serif; }
        
        /* Smooth Scrolling */
        * { scroll-behavior: smooth; }

        /* Custom Scrollbar */
        ::-webkit-scrollbar { width: 4px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #10b981; border-radius: 10px; }

        /* Animation */
        .fade-in-up {
            animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="overflow-x-hidden">
    <div class="flex min-h-screen">
        {{-- Fixed Sidebar Component --}}
        <livewire:admin.sidebar />

        {{-- Main Viewport --}}
        <main class="flex-1 ml-64 min-h-screen flex flex-col">
            {{-- Top Navbar --}}
            <header class="h-24 flex items-center justify-between px-12 sticky top-0 bg-black/80 backdrop-blur-md z-40 border-b border-white/[0.03]">
                <div class="flex flex-col p-5">
                    <span class="text-[10px] font-black text-emerald-500 uppercase tracking-[0.4em] mb-1">Control Center</span>
                    <h2 class="text-xs font-black text-white/40 uppercase tracking-[0.2em]">@yield('header_title', 'Operational Overview')</h2>
                </div>

                <div class="flex items-center gap-8">
                    <div class="hidden lg:flex items-center gap-3 px-6 py-2.5 bg-emerald-500/5 border border-emerald-500/20 rounded-full">
                        <div class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></div>
                        <span class="text-[9px] font-black text-emerald-500 uppercase tracking-widest italic">Node Status: Active</span>
                    </div>

                    <div class="flex items-center gap-4 group cursor-pointer">
                        <div class="text-right">
                            <p class="text-sm font-black text-white tracking-tight uppercase italic">{{ auth()->user()->name }}</p>
                            <p class="text-[9px] font-black text-emerald-500/50 uppercase tracking-widest">Master Auth</p>
                        </div>
                        <div class="w-12 h-12 rounded-2xl bg-emerald-500 flex items-center justify-center text-black font-black text-lg shadow-xl shadow-emerald-500/20 group-hover:scale-105 transition-transform">
                            {{ substr(auth()->user()->name, 0, 1) }}
                        </div>
                    </div>
                </div>
            </header>

            {{-- Content Area --}}
            <section class="flex-1 p-12 max-w-7xl">
                {{ $slot }}
            </section>

            {{-- Footer --}}
            <footer class="p-12 border-t border-white/[0.03]">
                <div class="flex justify-between items-center opacity-20">
                    <p class="text-[10px] font-black uppercase tracking-[0.3em]">Trackly OS v4.0</p>
                    <p class="text-[10px] font-black uppercase tracking-[0.3em]">Built for scale</p>
                </div>
            </footer>
        </main>
    </div>

    @livewireScripts
    @stack('scripts')
</body>
</html>
