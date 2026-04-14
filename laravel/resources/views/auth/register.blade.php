{{-- resources/views/auth/register.blade.php --}}
<!DOCTYPE html>
<html lang="id" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Akun — MoneyTrack</title>
    
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
                    <h2 class="text-4xl font-outfit font-extrabold tracking-tight text-white mb-2">Create Account</h2>
                    <p class="text-white/40 font-medium text-sm">Langkah awal menuju pengorganisasian finansial.</p>
                </div>

                <div class="mt-10">
                    <form method="POST" action="{{ route('register') }}" class="space-y-5">
                        @csrf
                        
                        <div>
                            <label for="name" class="block text-[10px] font-black text-white/40 uppercase tracking-[0.2em] mb-2 px-1">Nama Lengkap</label>
                            <input id="name" type="text" name="name" value="{{ old('name') }}" required autofocus
                                class="block w-full px-6 py-3.5 bg-white/5 border border-white/10 rounded-2xl text-white placeholder-white/20 focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 font-bold text-sm" 
                                placeholder="M. Fauzi">
                        </div>

                        <div>
                            <label for="email" class="block text-[10px] font-black text-white/40 uppercase tracking-[0.2em] mb-2 px-1">Alamat Email</label>
                            <input id="email" type="email" name="email" value="{{ old('email') }}" required
                                class="block w-full px-6 py-3.5 bg-white/5 border border-white/10 rounded-2xl text-white placeholder-white/20 focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 font-bold text-sm" 
                                placeholder="name@domain.com">
                            @error('email')
                                <p class="mt-2 text-xs font-bold text-rose-500 px-1">{{ $message }}</p>
                            @enderror
                        </div>

                        <div>
                            <label for="password" class="block text-[10px] font-black text-white/40 uppercase tracking-[0.2em] mb-2 px-1">Kata Sandi</label>
                            <input id="password" type="password" name="password" required
                                class="block w-full px-6 py-3.5 bg-white/5 border border-white/10 rounded-2xl text-white placeholder-white/20 focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 font-bold text-sm"
                                placeholder="Min. 8 karakter">
                            @error('password')
                                <p class="mt-2 text-xs font-bold text-rose-500 px-1">{{ $message }}</p>
                            @enderror
                        </div>

                        <div>
                            <label for="password_confirmation" class="block text-[10px] font-black text-white/40 uppercase tracking-[0.2em] mb-2 px-1">Konfirmasi Sandi</label>
                            <input id="password_confirmation" type="password" name="password_confirmation" required
                                class="block w-full px-6 py-3.5 bg-white/5 border border-white/10 rounded-2xl text-white placeholder-white/20 focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 font-bold text-sm"
                                placeholder="Ulangi kata sandi">
                        </div>

                        <div class="pt-4">
                            <button type="submit" 
                                class="w-full h-16 bg-emerald-500 hover:bg-emerald-400 text-black rounded-2xl font-black text-sm shadow-2xl shadow-emerald-500/20 transition-all duration-300 transform active:scale-[0.98] flex items-center justify-center gap-3">
                                Create Account
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
                                </svg>
                            </button>
                        </div>
                    </form>

                    <p class="mt-10 text-center text-sm font-bold text-white/40">
                        Sudah punya akun? 
                        <a href="{{ route('login') }}" class="text-emerald-500 hover:text-emerald-400 font-black transition-colors ml-1">Masuk Sekarang</a>
                    </p>
                </div>
            </div>
        </div>

        {{-- Right: Brand Section --}}
        <div class="relative hidden flex-1 lg:block overflow-hidden bg-[#0A0A0A]">
            <div class="absolute top-[-10%] right-[-10%] w-[60%] h-[60%] bg-emerald-500/10 rounded-full blur-[120px]"></div>
            <div class="absolute bottom-[-10%] left-[-10%] w-[40%] h-[40%] bg-blue-500/10 rounded-full blur-[100px]"></div>
            
            <div class="relative flex h-full flex-col justify-center px-24">
                <div class="mb-12">
                    <div class="w-20 h-20 bg-emerald-500 rounded-3xl flex items-center justify-center text-black shadow-2xl shadow-emerald-500/40 mb-8">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-12 h-12" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                        </svg>
                    </div>
                    <h1 class="text-7xl font-outfit font-black text-white tracking-tighter italic leading-none">Smart<span class="text-emerald-500">Wealth</span>.</h1>
                </div>
                
                <div class="max-w-xl space-y-6">
                    <h2 class="text-3xl font-bold text-white leading-tight">Mulai perjalanan finansialmu secara profesional.</h2>
                    <p class="text-xl text-white/40 leading-relaxed font-medium">MoneyTrack dirancang untuk memudahkanmu memahami ke mana uangmu pergi. Dapatkan laporan visual harian dan bulanan tanpa ribet.</p>
                </div>

                {{-- List --}}
                <div class="mt-16 space-y-6">
                    <div class="flex items-center gap-4">
                        <div class="w-6 h-6 rounded-full bg-emerald-500/20 flex items-center justify-center text-emerald-500">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                            </svg>
                        </div>
                        <p class="text-white/60 font-bold">Laporan Real-time</p>
                    </div>
                    <div class="flex items-center gap-4">
                        <div class="w-6 h-6 rounded-full bg-emerald-500/20 flex items-center justify-center text-emerald-500">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                            </svg>
                        </div>
                        <p class="text-white/60 font-bold">Kategori Kustom</p>
                    </div>
                </div>
            </div>

            <div class="absolute bottom-12 left-24">
                <p class="text-[10px] font-black text-white/20 uppercase tracking-[0.4em]">© 2026 MoneyTrack Global Corp.</p>
            </div>
        </div>
    </div>

</body>
</html>
