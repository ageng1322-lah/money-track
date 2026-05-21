<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoneyTrack — Solusi Keuangan Pintar</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@600;700;800;900&family=Space+Grotesk:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['"Space Grotesk"', 'sans-serif'],
                        outfit: ['"Space Grotesk"', 'sans-serif'],
                    },
                    colors: {
                        brand: {
                            50: '#ecfdf5',
                            400: '#34d399',
                            500: '#10b981',
                            600: '#059669',
                        }
                    },
                    animation: {
                        'float': 'float 6s ease-in-out infinite',
                        'float-slow': 'float 8s ease-in-out infinite',
                        'float-fast': 'float 4s ease-in-out infinite',
                        'pulse-slow': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
                    },
                    keyframes: {
                        float: {
                            '0%, 100%': { transform: 'translateY(0)' },
                            '50%': { transform: 'translateY(-20px)' },
                        }
                    }
                }
            }
        }
    </script>
    <style>
        body {
            background-color: #000000;
            color: #ffffff;
            overflow-x: hidden;
            scroll-behavior: smooth;
        }
        .glass-nav {
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .text-gradient {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .mask-radial {
            mask-image: radial-gradient(circle at center, black, transparent 80%);
        }
    </style>
</head>
<body class="antialiased selection:bg-brand-500 selection:text-black">

    <!-- Navbar -->
    <nav class="fixed w-full z-50 glass-nav transition-all duration-300">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-gradient-to-tr from-brand-600 to-brand-400 flex items-center justify-center shadow-lg shadow-brand-500/20">
                        <svg class="w-6 h-6 text-black" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <span class="text-xl font-black font-outfit tracking-tighter text-white uppercase italic">Money<span class="text-brand-500">Track</span>.</span>
                </div>
                
                <div class="flex items-center gap-6">
                    @auth
                        <a href="{{ route('dashboard') }}" class="text-sm font-bold text-white/60 hover:text-white transition-colors">DASHBOARD</a>
                        <form method="POST" action="{{ route('logout') }}" class="inline">
                            @csrf
                            <button type="submit" class="text-sm font-bold text-rose-500 hover:text-rose-400 transition-colors uppercase">KELUAR</button>
                        </form>
                    @else
                        <a href="{{ route('login') }}" class="text-sm font-bold text-white/60 hover:text-white transition-colors uppercase group">
                            Masuk
                            <span class="block max-w-0 group-hover:max-w-full transition-all duration-500 h-0.5 bg-brand-500"></span>
                        </a>
                        <a href="{{ route('register') }}" class="px-6 py-2.5 bg-white text-black text-xs font-black rounded-full hover:bg-brand-500 hover:scale-105 transition-all duration-300 uppercase tracking-widest">
                            Daftar Sekarang
                        </a>
                    @endauth
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <main class="relative pt-32 lg:pt-48 pb-16 overflow-hidden min-h-screen">
        <!-- Background Orbs -->
        <div class="absolute top-0 left-1/2 -translate-x-1/2 w-[1000px] h-[600px] bg-brand-500/10 rounded-full blur-[120px] pointer-events-none opacity-50"></div>
        <div class="absolute -top-24 -left-24 w-96 h-96 bg-blue-500/5 rounded-full blur-[100px] pointer-events-none animate-pulse-slow"></div>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col lg:flex-row items-center gap-16 relative">
            
            {{-- Left Content: Text --}}
            <div class="flex-1 text-center lg:text-left">
                <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full border border-white/10 bg-white/5 text-[10px] font-black uppercase tracking-[0.2em] text-brand-400 mb-10">
                    <span class="relative flex h-2 w-2">
                        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-brand-400 opacity-75"></span>
                        <span class="relative inline-flex rounded-full h-2 w-2 bg-brand-500"></span>
                    </span>
                    Financial Freedom Starts Here
                </div>
                
                <h1 class="text-6xl sm:text-7xl lg:text-8xl font-black font-outfit uppercase leading-[0.9] tracking-tighter mb-8 italic">
                    MANAGE YOUR <br>
                    <span class="text-gradient">CAPITAL</span> <br>
                    SMARTER.
                </h1>
                
                <p class="max-w-xl text-lg text-white/40 font-medium leading-relaxed mb-10 mx-auto lg:mx-0">
                    Sistem pencatatan keuangan modern yang membantu Anda memonitor setiap transaksi dengan efektif. Pahami pola pengeluaranmu secara real-time.
                </p>
                
                <div class="flex flex-wrap justify-center lg:justify-start gap-4">
                    <a href="{{ route('register') }}" class="h-16 px-10 bg-brand-500 hover:bg-brand-400 text-black rounded-2xl flex items-center justify-center font-black text-sm uppercase tracking-widest transition-all duration-300 hover:scale-[1.02] active:scale-95 shadow-lg shadow-brand-500/20">
                        Get Started Now
                    </a>
                    <a href="#fitur" class="h-16 px-10 border border-white/10 bg-white/5 hover:bg-white/10 text-white rounded-2xl flex items-center justify-center font-black text-sm uppercase tracking-widest transition-all duration-300">
                        View Features
                    </a>
                </div>

                <div class="mt-12 flex items-center justify-center lg:justify-start gap-4 opacity-50">
                    <div class="flex -space-x-2">
                        <img class="w-8 h-8 rounded-full border-2 border-black" src="https://i.pravatar.cc/100?img=1" alt="">
                        <img class="w-8 h-8 rounded-full border-2 border-black" src="https://i.pravatar.cc/100?img=2" alt="">
                        <img class="w-8 h-8 rounded-full border-2 border-black" src="https://i.pravatar.cc/100?img=3" alt="">
                    </div>
                    <span class="text-[10px] font-bold uppercase tracking-widest">Trusted by 5,000+ users</span>
                </div>
            </div>

            {{-- Right Content: Floating Cards Section --}}
            <div class="flex-1 relative w-full lg:w-auto h-[600px] flex items-center justify-center">
                <div class="relative w-[320px] sm:w-[480px] h-[580px]">
                    
                    {{-- Abstract Shapes --}}
                    <div class="absolute -top-12 -left-8 w-24 h-24 rounded-full border-[14px] border-[#111111] opacity-90 backdrop-blur-md animate-float-slow"></div>
                    <div class="absolute -bottom-8 -right-4 w-32 h-32 rounded-full border-[20px] border-[#0a0a0a] z-30 transform rotate-12 animate-float"></div>

                    {{-- Card 1: Balance (Top Left) --}}
                    <div class="absolute top-10 -left-6 sm:-left-12 bg-[#111111] border border-white/10 rounded-[2rem] p-6 shadow-2xl z-20 w-64 animate-float-slow transition-transform hover:scale-105 duration-500">
                        <div class="flex items-center gap-3 mb-4">
                            <div class="w-8 h-8 rounded-lg bg-emerald-500/20 flex items-center justify-center text-emerald-500">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" />
                                </svg>
                            </div>
                            <div class="text-[9px] text-white/30 font-black uppercase tracking-widest">Total Balance</div>
                        </div>
                        <div class="text-3xl font-outfit font-black text-white">$12,450.00</div>
                        <div class="mt-4 flex items-center gap-2">
                            <span class="text-[10px] font-black text-emerald-500">+12.5%</span>
                            <div class="flex-1 h-1 bg-white/5 rounded-full overflow-hidden">
                                <div class="bg-emerald-500 w-3/4 h-full rounded-full"></div>
                            </div>
                        </div>
                    </div>

                    {{-- Card 2: Main Preview Card --}}
                    <div class="absolute top-24 left-8 right-8 bottom-24 bg-[#0A0A0A] border border-white/10 rounded-[3rem] p-6 shadow-2xl z-10 overflow-hidden flex flex-col group transition-all duration-500">
                        {{-- Decorative background in card --}}
                        <div class="absolute top-0 right-0 w-40 h-40 bg-brand-500/10 rounded-full blur-[60px] group-hover:bg-brand-500/20 transition-colors"></div>
                        
                        <div class="relative flex-1 bg-white/5 rounded-[2rem] border border-white/5 p-5 mb-6 flex flex-col overflow-hidden">
                            <div class="flex justify-between items-center mb-6">
                                <div class="w-12 h-4 bg-white/10 rounded-full"></div>
                                <div class="w-8 h-8 rounded-full bg-brand-500/20 flex items-center justify-center">
                                    <div class="w-4 h-1 bg-brand-500 rounded-full"></div>
                                </div>
                            </div>
                            
                            {{-- Chart mockup lines --}}
                            <div class="flex-1 flex items-end gap-2 px-2">
                                <div class="w-full bg-brand-500/10 h-[20%] rounded-t-lg group-hover:h-[40%] transition-all duration-700"></div>
                                <div class="w-full bg-brand-500/20 h-[50%] rounded-t-lg group-hover:h-[30%] transition-all duration-1000"></div>
                                <div class="w-full bg-brand-500/40 h-[80%] rounded-t-lg group-hover:h-[90%] transition-all duration-500"></div>
                                <div class="w-full bg-brand-500/10 h-[40%] rounded-t-lg group-hover:h-[60%] transition-all duration-800"></div>
                                <div class="w-full bg-brand-500/60 h-[90%] rounded-t-lg group-hover:h-[100%] transition-all duration-600"></div>
                            </div>
                        </div>

                        <div class="space-y-2">
                            <h3 class="text-xl font-outfit font-black text-white italic tracking-tighter uppercase leading-none">Smart Analytics</h3>
                            <p class="text-[10px] text-white/40 font-bold tracking-widest uppercase">Pahami setiap aliran dana Anda</p>
                            <div class="pt-4 mt-2 border-t border-white/5 flex gap-4">
                                <div class="flex flex-col">
                                    <span class="text-[8px] text-white/20 font-black uppercase">Income</span>
                                    <span class="text-xs font-black text-emerald-500">+$2.4k</span>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-[8px] text-white/20 font-black uppercase">Expense</span>
                                    <span class="text-xs font-black text-rose-500">-$1.2k</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    {{-- Card 3: Recent Activity (Bottom Left) --}}
                    <div class="absolute bottom-20 -left-10 bg-brand-500 border border-brand-400/50 rounded-3xl p-5 shadow-2xl z-20 w-64 animate-float transform translate-x-4 transition-transform hover:scale-105 duration-500">
                        <div class="text-black font-black text-[10px] uppercase tracking-widest mb-4 opacity-60">Recent Activity</div>
                        <div class="space-y-3">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-black/10 flex items-center justify-center text-black">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
                                    </svg>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <div class="text-xs font-black text-black truncate">Grocery Store</div>
                                    <div class="text-[8px] font-bold text-black/50">Today, 2:45 PM</div>
                                </div>
                                <div class="text-xs font-black text-black">-$42.00</div>
                            </div>
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-black/10 flex items-center justify-center text-black">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <div class="text-xs font-black text-black truncate">Salary Deposit</div>
                                    <div class="text-[8px] font-bold text-black/50">Yesterday</div>
                                </div>
                                <div class="text-xs font-black text-black">+$2.5k</div>
                            </div>
                        </div>
                    </div>

                    {{-- Card 4: Price Badge (Bottom Right) --}}
                    <div class="absolute bottom-12 -right-4 sm:-right-8 bg-black border border-white/10 rounded-full p-2.5 pl-6 shadow-2xl z-20 flex items-center gap-5 scale-90 sm:scale-100 animate-pulse-slow">
                        <div class="text-white font-outfit font-black text-xl">$0 <span class="text-[9px] text-white/30 font-medium normal-case font-sans tracking-tight leading-none italic block -mt-1">free forever</span></div>
                        <a href="{{ route('register') }}" class="bg-white text-black px-5 py-3 rounded-full text-[10px] font-black uppercase tracking-widest hover:bg-brand-500 transition-all duration-300">Join Now</a>
                    </div>

                </div>
            </div>
        </div>
    </main>

    <!-- Features Grid -->
    <section id="fitur" class="py-32 relative bg-[#050505]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="mb-20 text-center">
                <div class="text-brand-500 font-black text-[10px] tracking-[0.3em] uppercase mb-4">Core Engine</div>
                <h2 class="text-4xl md:text-5xl lg:text-7xl font-black font-outfit italic tracking-tighter uppercase leading-none">
                    ENGINEERED FOR <br>
                    <span class="text-brand-500">PERFORMANCE.</span>
                </h2>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Feature 1 -->
                <div class="group relative bg-[#0A0A0A] border border-white/5 rounded-[3rem] p-10 hover:border-brand-500/30 transition-all duration-500 overflow-hidden">
                    <div class="absolute -right-20 -top-20 w-60 h-60 bg-brand-500/5 rounded-full blur-[60px] group-hover:bg-brand-500/10 transition-colors"></div>
                    <div class="w-16 h-16 rounded-[1.5rem] bg-white/5 flex items-center justify-center mb-10 group-hover:bg-brand-500 group-hover:text-black transition-all duration-500">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-black font-outfit italic uppercase tracking-tighter mb-4">Lightning Fast</h3>
                    <p class="text-white/40 text-sm leading-relaxed font-medium">Input transaksi pendapatan atau pengeluaran hanya dalam hitungan detik. Tanpa loading layar yang lama.</p>
                </div>

                <!-- Feature 2 -->
                <div class="group relative bg-[#0A0A0A] border border-brand-500/20 rounded-[3rem] p-10 hover:bg-brand-500/5 transition-all duration-500 overflow-hidden shadow-2xl shadow-brand-500/5">
                    <div class="absolute -right-20 -top-20 w-60 h-60 bg-brand-500/20 rounded-full blur-[60px]"></div>
                    <div class="w-16 h-16 rounded-[1.5rem] bg-brand-500 text-black flex items-center justify-center mb-10">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-black font-outfit italic uppercase tracking-tighter mb-4">Deep Insights</h3>
                    <p class="text-white/40 text-sm leading-relaxed font-medium">Monitor arus kas Anda dengan grafik visual yang interaktif. Lacak kemana perginya uang Anda secara presisi.</p>
                </div>

                <!-- Feature 3 -->
                <div class="group relative bg-[#0A0A0A] border border-white/5 rounded-[3rem] p-10 hover:border-brand-500/30 transition-all duration-500 overflow-hidden">
                    <div class="absolute -right-20 -top-20 w-60 h-60 bg-blue-500/5 rounded-full blur-[60px] group-hover:bg-blue-500/10 transition-colors"></div>
                    <div class="w-16 h-16 rounded-[1.5rem] bg-white/5 flex items-center justify-center mb-10 group-hover:bg-emerald-500 group-hover:text-black transition-all duration-500">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-black font-outfit italic uppercase tracking-tighter mb-4">Fortified Security</h3>
                    <p class="text-white/40 text-sm leading-relaxed font-medium">Data Anda tersimpan dengan aman dengan enkripsi modern tingkat tinggi. Fokus pada masa depan, bukan keamanan.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="py-20 border-t border-white/5 bg-black overflow-hidden relative">
        <div class="absolute bottom-0 left-1/2 -translate-x-1/2 w-full h-[300px] bg-brand-500/5 blur-[100px] mask-radial"></div>
        
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <div class="flex items-center justify-center gap-3 mb-8">
                <div class="w-8 h-8 rounded-lg bg-brand-500 flex items-center justify-center">
                    <svg class="w-5 h-5 text-black" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
                <span class="text-2xl font-black font-outfit tracking-tighter text-white uppercase italic">Money<span class="text-brand-500">Track</span>.</span>
            </div>
            
            <p class="text-white/30 text-xs font-bold tracking-[0.3em] uppercase mb-10">TAKE CONTROL OF YOUR WEALTH TODAY</p>
            
            <div class="flex justify-center gap-10 text-[10px] font-black uppercase tracking-widest text-white/40 mb-10">
                <a href="#" class="hover:text-brand-400 transition-colors">Privacy Policy</a>
                <a href="#" class="hover:text-brand-400 transition-colors">Terms of Service</a>
                <a href="#" class="hover:text-brand-400 transition-colors">Contact Us</a>
            </div>

            <p class="text-white/20 text-[10px] font-bold">&copy; {{ date('Y') }} MoneyTrack. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
