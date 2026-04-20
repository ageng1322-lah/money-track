{{-- resources/views/auth/register.blade.php --}}
<!DOCTYPE html>
<html lang="id">
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
<body class="bg-black text-white antialiased overflow-x-hidden">

    <div class="flex min-h-screen bg-[#000000] p-3 sm:p-4 lg:p-6">
        {{-- Left: Cards Section --}}
        <div class="relative hidden lg:flex flex-1 flex-col items-center justify-center overflow-hidden bg-[#0A0A0A] rounded-[2.5rem] border border-white/5">
            
            {{-- Abstract Shapes / Coils --}}
            <div class="absolute top-[15%] left-[20%] w-[50%] h-[50%] bg-emerald-500/10 rounded-full blur-[120px]"></div>
            
            <div class="relative w-[480px] h-[580px]">
                
                {{-- Abstract 3D Coils (Simulated with pure CSS) --}}
                <div class="absolute -top-12 -left-8 w-24 h-24 rounded-full border-[14px] border-[#1f1f1f] shadow-[0_0_50px_rgba(0,0,0,0.5)] opacity-90 backdrop-blur-md"></div>
                <div class="absolute -bottom-8 -right-4 w-32 h-32 rounded-full border-[20px] border-[#151515] shadow-2xl opacity-90 backdrop-blur-sm z-30 transform rotate-12"></div>

                {{-- Card 1: Total Revenue (Top Right) --}}
                <div class="absolute top-6 right-4 lg:-right-4 bg-[#141414] border border-white/10 rounded-2xl p-5 shadow-2xl z-20 w-56 animate-[pulse_4s_infinite]">
                    <div class="text-[11px] text-white font-bold tracking-wide mb-1">Total Revenue</div>
                    <div class="text-[9px] text-white/40 mb-3 font-medium">Jul 1 - 28</div>
                    <div class="flex justify-between items-end">
                        <div class="text-2xl font-outfit font-black text-white">$120.29</div>
                        <div class="bg-emerald-500/20 text-emerald-500 text-[10px] font-black px-2.5 py-1 rounded-full">+12%</div>
                    </div>
                    <div class="mt-4 bg-white/5 w-full h-1.5 rounded-full overflow-hidden">
                        <div class="bg-emerald-500 w-3/4 h-full rounded-full"></div>
                    </div>
                </div>

                {{-- Card 2: Main Big Card (Center) --}}
                <div class="absolute top-24 left-8 right-8 bottom-24 bg-[#141414] border border-white/10 rounded-3xl p-6 shadow-2xl z-10 flex flex-col">
                    {{-- Upper Illustration Area --}}
                    <div class="flex-1 bg-gradient-to-br from-emerald-500/10 via-emerald-500/5 to-transparent rounded-2xl relative overflow-hidden mb-5 border border-white/5">
                        <div class="absolute top-4 left-4 bg-white/10 backdrop-blur-md px-3 py-1.5 rounded-full text-[10px] text-white font-bold tracking-wider">Beginner</div>
                        
                        {{-- Inner floating elements --}}
                        <div class="absolute inset-0 flex items-center justify-center">
                            <div class="w-40 h-28 bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl relative shadow-2xl transform rotate-[-5deg]">
                                <div class="absolute -top-4 -right-2 bg-emerald-500/20 text-emerald-400 text-[9px] tracking-wider px-2 py-1 rounded-full font-black uppercase">Pro Features</div>
                                <div class="flex flex-col h-full items-center justify-center gap-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-emerald-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012-2h-2a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                                    </svg>
                                    <div class="w-20 h-1.5 rounded-full bg-white/10 mt-1"></div>
                                    <div class="w-12 h-1.5 rounded-full bg-white/10"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    {{-- Text Content --}}
                    <div class="space-y-1.5">
                        <h3 class="text-white font-outfit font-black text-xl uppercase tracking-tight">ACHIEVE FINANCIAL FREEDOM</h3>
                        <p class="text-emerald-500 text-[11px] font-bold tracking-wide">by MoneyTrack</p>
                        <div class="flex gap-4 text-[10px] text-white/50 font-medium pt-3 border-t border-white/5 mt-3">
                            <span class="flex items-center gap-1">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>
                                12 Modules
                            </span>
                            <span class="flex items-center gap-1">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                                2 hours
                            </span>
                        </div>
                    </div>
                </div>

                {{-- Card 3: Happy Students (Bottom Left) --}}
                <div class="absolute bottom-24 -left-8 bg-blue-600 border border-blue-500/50 rounded-2xl p-4 shadow-2xl z-30 w-60 transform translate-y-6">
                    <div class="text-white font-bold text-xs mb-1">Happy Users</div>
                    <div class="text-white/90 text-[11px] mb-3 flex items-center gap-1 font-medium">
                        4.9 (500) 
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 text-yellow-400 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" /></svg>
                    </div>
                    <div class="flex -space-x-3">
                        <div class="w-9 h-9 rounded-full bg-cover bg-center border-2 border-blue-600 shadow-sm" style="background-image: url('https://i.pravatar.cc/100?img=33')"></div>
                        <div class="w-9 h-9 rounded-full bg-cover bg-center border-2 border-blue-600 shadow-sm" style="background-image: url('https://i.pravatar.cc/100?img=47')"></div>
                        <div class="w-9 h-9 rounded-full bg-cover bg-center border-2 border-blue-600 shadow-sm" style="background-image: url('https://i.pravatar.cc/100?img=12')"></div>
                        <div class="w-9 h-9 rounded-full bg-white border-2 border-blue-600 flex items-center justify-center text-[10px] text-blue-600 font-extrabold shadow-sm">10K+</div>
                    </div>
                </div>

                {{-- Card 4: Enroll / Price (Bottom Right, attached to main card) --}}
                <div class="absolute bottom-16 right-4 lg:-right-0 bg-[#000000] border border-white/10 rounded-full p-2 pl-6 shadow-2xl z-20 flex items-center gap-5">
                    <div class="text-white font-outfit font-black text-xl">$0 <span class="text-[10px] text-white/40 font-medium normal-case font-sans">/lifetime</span></div>
                    <button class="bg-white text-black px-5 py-3 rounded-full text-xs font-bold hover:bg-white/90 hover:scale-105 transition-all duration-300 tracking-wide">Register Now</button>
                </div>

            </div>
        </div>

        {{-- Right: Form Section --}}
        <div class="flex flex-1 flex-col justify-center px-8 py-12 sm:px-12 lg:px-24 xl:px-32 bg-[#000000] z-10 relative overflow-y-auto">
            <div class="mx-auto w-full max-w-[400px]">
                
                {{-- Form Header matching the photo --}}
                <div class="mb-10">
                    <h1 class="text-xl font-outfit font-black text-white italic tracking-tighter mb-12">Money<span class="text-emerald-500">Track</span>.</h1>
                    
                    <div class="text-emerald-500 font-bold text-sm tracking-wide mb-2">Create an Account</div>
                    <h2 class="text-4xl sm:text-[2.75rem] leading-[1.1] font-outfit font-black tracking-tighter text-white mb-2 uppercase">WELCOME TO <br>MONEYTRACK</h2>
                </div>

                <div>
                    <form method="POST" action="{{ route('register') }}" class="space-y-5">
                        @csrf
                        
                        <div>
                            <label for="name" class="block text-xs font-bold text-white/80 mb-2">Full Name</label>
                            <input id="name" type="text" name="name" value="{{ old('name') }}" required autofocus
                                class="block w-full px-5 py-4 bg-transparent border border-white/10 rounded-xl text-white placeholder-white/20 focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 font-medium text-sm" 
                                placeholder="Jamie Davis">
                        </div>

                        <div>
                            <label for="email" class="block text-xs font-bold text-white/80 mb-2">Email</label>
                            <input id="email" type="email" name="email" value="{{ old('email') }}" required
                                class="block w-full px-5 py-4 bg-transparent border border-white/10 rounded-xl text-white placeholder-white/20 focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 font-medium text-sm" 
                                placeholder="designer@example.com">
                            @error('email')
                                <p class="mt-2 text-xs font-bold text-rose-500">{{ $message }}</p>
                            @enderror
                        </div>

                        <div>
                            <label for="password" class="block text-xs font-bold text-white/80 mb-2">Password</label>
                            <input id="password" type="password" name="password" required
                                class="block w-full px-5 py-4 bg-transparent border border-white/10 rounded-xl text-white placeholder-white/20 focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 font-medium text-sm"
                                placeholder="••••••••">
                            @error('password')
                                <p class="mt-2 text-xs font-bold text-rose-500">{{ $message }}</p>
                            @enderror
                        </div>

                        <div>
                            <label for="password_confirmation" class="block text-xs font-bold text-white/80 mb-2">Confirm Password</label>
                            <input id="password_confirmation" type="password" name="password_confirmation" required
                                class="block w-full px-5 py-4 bg-transparent border border-white/10 rounded-xl text-white placeholder-white/20 focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 font-medium text-sm"
                                placeholder="••••••••">
                        </div>

                        <div class="pt-6">
                            <button type="submit" 
                                class="w-full h-14 bg-emerald-500 hover:bg-emerald-400 text-black rounded-xl font-bold text-sm transition-all duration-300 transform active:scale-[0.98]">
                                Continue
                            </button>
                        </div>
                    </form>

                    <p class="mt-10 text-center text-sm font-medium text-white/40">
                        Already have an account? 
                        <a href="{{ route('login') }}" class="text-emerald-500 hover:text-emerald-400 font-bold transition-colors ml-1">Login</a>
                    </p>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
