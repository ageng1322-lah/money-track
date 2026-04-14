{{-- resources/views/auth/login.blade.php --}}
<!DOCTYPE html>
<html lang="id" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masuk — MoneyTrack</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">

    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <style>
        body { font-family: 'Inter', sans-serif; }
        .font-outfit { font-family: 'Outfit', sans-serif; }
    </style>
</head>
<body class="h-full bg-black text-white antialiased overflow-hidden">

    <div class="flex min-h-full">
        {{-- Left: Form Section --}}
        <div class="flex flex-1 flex-col justify-center px-8 py-12 sm:px-12 lg:flex-none lg:px-24 xl:px-32 bg-black z-10 relative">
            <div class="mx-auto w-full max-w-sm lg:w-96">
                <div>
                    <h2 class="text-4xl font-outfit font-extrabold tracking-tight text-white mb-2">Welcome Back</h2>
                    <p class="text-white/40 font-medium text-sm">Masuk untuk mengelola keuangan masa depanmu.</p>
                </div>

                <div class="mt-12">
                    <form method="POST" action="{{ route('login') }}" class="space-y-6">
                        @csrf
                        
                        <div>
                            <label for="email" class="block text-[10px] font-black text-white/40 uppercase tracking-[0.2em] mb-3 px-1">Alamat Email</label>
                            <input id="email" type="email" name="email" value="{{ old('email') }}" required autofocus
                                class="block w-full px-6 py-4 bg-white/5 border border-white/10 rounded-2xl text-white placeholder-white/20 focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 font-bold text-sm" 
                                placeholder="name@domain.com">
                            @error('email')
                                <p class="mt-2 text-xs font-bold text-rose-500 px-1">{{ $message }}</p>
                            @enderror
                        </div>

                        <div>
                            <div class="flex items-center justify-between mb-3 px-1">
                                <label for="password" class="block text-[10px] font-black text-white/40 uppercase tracking-[0.2em]">Kata Sandi</label>
                                <a href="#" class="text-[10px] font-black text-emerald-500 hover:text-emerald-400 uppercase tracking-widest transition-colors">Lupa sandi?</a>
                            </div>
                            <input id="password" type="password" name="password" required
                                class="block w-full px-6 py-4 bg-white/5 border border-white/10 rounded-2xl text-white placeholder-white/20 focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 font-bold text-sm"
                                placeholder="••••••••">
                        </div>

                        <div class="flex items-center px-1">
                            <input id="remember" type="checkbox" name="remember" class="w-5 h-5 rounded-lg border-white/10 bg-white/5 text-emerald-500 focus:ring-emerald-500 transition-all cursor-pointer">
                            <label for="remember" class="ml-3 block text-sm font-bold text-white/60 cursor-pointer">Ingat saya di perangkat ini</label>
                        </div>

                        <div class="pt-4">
                            <button type="submit" 
                                class="w-full h-16 bg-emerald-500 hover:bg-emerald-400 text-black rounded-2xl font-black text-sm shadow-2xl shadow-emerald-500/20 transition-all duration-300 transform active:scale-[0.98] flex items-center justify-center gap-3">
                                Sign In Now
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                                </svg>
                            </button>
                        </div>
                    </form>

                    <div class="mt-12 text-center h-[1px] bg-white/5 relative">
                        <span class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-black px-4 text-[10px] font-black text-white/20 uppercase tracking-[0.2em]">Atau</span>
                    </div>

                    <p class="mt-12 text-center text-sm font-bold text-white/40">
                        Baru di MoneyTrack? 
                        <a href="{{ route('register') }}" class="text-emerald-500 hover:text-emerald-400 font-black transition-colors ml-1">Buka Akun Gratis</a>
                    </p>
                </div>
            </div>
        </div>

        {{-- Right: Brand Section --}}
        <div class="relative hidden flex-1 lg:block overflow-hidden bg-[#0A0A0A]">
            {{-- Abstract Shapes --}}
            <div class="absolute top-[-10%] right-[-10%] w-[60%] h-[60%] bg-emerald-500/10 rounded-full blur-[120px]"></div>
            <div class="absolute bottom-[-10%] left-[-10%] w-[40%] h-[40%] bg-blue-500/10 rounded-full blur-[100px]"></div>
            
            <div class="relative flex h-full flex-col justify-center px-24">
                <div class="mb-12">
                    <div class="w-20 h-20 bg-emerald-500 rounded-3xl flex items-center justify-center text-black shadow-2xl shadow-emerald-500/40 mb-8">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-12 h-12" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <h1 class="text-7xl font-outfit font-black text-white tracking-tighter italic leading-none">Money<span class="text-emerald-500">Track</span>.</h1>
                </div>
                
                <div class="max-w-xl space-y-6">
                    <h3 class="text-3xl font-bold text-white leading-tight">Mencatat keuangan bukan lagi hal yang membosankan.</h3>
                    <p class="text-xl text-white/40 leading-relaxed font-medium">MoneyTrack membantu ribuan orang mengelola arus kas dengan antarmuka yang modern, cepat, dan sepenuhnya aman. Mulai kebebasan finansialmu hari ini.</p>
                </div>

                {{-- Stats --}}
                <div class="mt-16 grid grid-cols-2 gap-12">
                    <div>
                        <p class="text-4xl font-black font-outfit text-white">99.9%</p>
                        <p class="text-sm font-bold text-white/20 uppercase tracking-widest mt-1">Uptime Sytem</p>
                    </div>
                    <div>
                        <p class="text-4xl font-black font-outfit text-emerald-500">256-bit</p>
                        <p class="text-sm font-bold text-white/20 uppercase tracking-widest mt-1">Encryption</p>
                    </div>
                </div>
            </div>

            {{-- Footer Info --}}
            <div class="absolute bottom-12 left-24">
                <p class="text-[10px] font-black text-white/20 uppercase tracking-[0.4em]">© 2026 MoneyTrack Global Corp.</p>
            </div>
        </div>
    </div>

</body>
</html>
