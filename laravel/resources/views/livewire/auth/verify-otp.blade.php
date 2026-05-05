<div class="flex min-h-screen bg-[#000000] p-3 sm:p-4 lg:p-6 text-white overflow-hidden relative">
    {{-- Background Decorative Elements --}}
    <div class="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-emerald-500/10 rounded-full blur-[120px] animate-pulse"></div>
    <div class="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-blue-500/10 rounded-full blur-[120px] animate-pulse" style="animation-delay: 2s;"></div>

    {{-- Floating Decorative Cards (Matching Register Page Style) --}}
    {{-- Card 1: Security Status (Top Right) --}}
    <div class="absolute top-12 right-12 hidden xl:block bg-[#141414] border border-white/10 rounded-2xl p-5 shadow-2xl z-20 w-64 animate-float">
        <div class="flex items-center gap-3 mb-4">
            <div class="p-2 bg-emerald-500/20 rounded-lg">
                <svg class="w-5 h-5 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
                </svg>
            </div>
            <div>
                <div class="text-[11px] text-white font-bold tracking-wide">Security Check</div>
                <div class="text-[9px] text-white/40 font-medium">Verification in progress...</div>
            </div>
        </div>
        <div class="space-y-2">
            <div class="h-1.5 bg-white/5 rounded-full overflow-hidden">
                <div class="bg-emerald-500 w-2/3 h-full rounded-full animate-pulse"></div>
            </div>
            <div class="flex justify-between text-[9px] font-bold">
                <span class="text-white/40">Step 2/3</span>
                <span class="text-emerald-500">67% Secured</span>
            </div>
        </div>
    </div>

    {{-- Card 2: User Activity (Bottom Left) --}}
    <div class="absolute bottom-12 left-12 hidden xl:block bg-[#141414] border border-white/10 rounded-2xl p-5 shadow-2xl z-20 w-60 animate-float-delayed">
        <div class="text-white font-bold text-xs mb-3 flex items-center gap-2">
            <span class="w-2 h-2 bg-blue-500 rounded-full animate-ping"></span>
            Live Verification
        </div>
        <div class="flex -space-x-3 mb-4">
            <div class="w-8 h-8 rounded-full bg-cover bg-center border-2 border-[#141414]" style="background-image: url('https://i.pravatar.cc/100?img=11')"></div>
            <div class="w-8 h-8 rounded-full bg-cover bg-center border-2 border-[#141414]" style="background-image: url('https://i.pravatar.cc/100?img=12')"></div>
            <div class="w-8 h-8 rounded-full bg-cover bg-center border-2 border-[#141414]" style="background-image: url('https://i.pravatar.cc/100?img=13')"></div>
            <div class="w-8 h-8 rounded-full bg-blue-600 flex items-center justify-center text-[8px] text-white font-black border-2 border-[#141414]">10K+</div>
        </div>
        <p class="text-[10px] text-white/50 leading-relaxed font-medium">Join 10,000+ users managing their finances smarter.</p>
    </div>

    <div class="flex flex-1 flex-col justify-center items-center z-10">
        {{-- Main Verification Card --}}
        <div class="w-full max-w-[480px] bg-[#0A0A0A] border border-white/10 rounded-[2.5rem] p-8 sm:p-12 shadow-2xl relative overflow-hidden backdrop-blur-sm transform transition-all duration-500 hover:scale-[1.01]">
            
            {{-- Abstract Coil --}}
            <div class="absolute -top-6 -right-6 w-20 h-20 rounded-full border-[10px] border-[#1f1f1f] shadow-2xl opacity-40 transform rotate-12"></div>

            <div class="mb-10 text-center">
                <h1 class="text-xl font-outfit font-black text-white italic tracking-tighter mb-8">Money<span class="text-emerald-500">Track</span>.</h1>
                
                <div class="text-emerald-500 font-bold text-sm tracking-wide mb-2 uppercase animate-fade-in-down">Verification Required</div>
                <h2 class="text-3xl sm:text-4xl leading-[1.1] font-outfit font-black tracking-tighter text-white mb-4 uppercase">ENTER OTP CODE</h2>
                <p class="text-white/50 text-sm font-medium">
                    We've sent a 4-digit code to <br>
                    <span class="text-white font-bold">{{ auth()->user()->email }}</span>
                </p>
            </div>

            {{-- Messages --}}
            @if (session()->has('message'))
                <div class="mb-6 p-4 rounded-2xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-500 text-xs font-bold flex items-center animate-bounce-short">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    {{ session('message') }}
                </div>
            @endif

            @if ($error)
                <div class="mb-6 p-4 rounded-2xl bg-rose-500/10 border border-rose-500/20 text-rose-500 text-xs font-bold flex items-center animate-shake">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    {{ $error }}
                </div>
            @endif

            <form wire:submit.prevent="verify" class="space-y-8">
                <div class="relative group">
                    <div class="flex justify-center gap-4">
                        <input wire:model.defer="otp" type="text" maxlength="4" autofocus
                            class="w-full bg-[#141414] border border-white/10 rounded-2xl px-5 py-6 text-center text-5xl tracking-[0.5em] font-outfit font-black text-white focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all duration-300 placeholder-white/5 shadow-inner"
                            placeholder="0000">
                    </div>
                    @error('otp') <p class="mt-2 text-center text-xs font-bold text-rose-500">{{ $message }}</p> @enderror
                </div>

                <button type="submit" 
                    class="w-full h-16 bg-emerald-500 hover:bg-emerald-400 text-black rounded-2xl font-black text-sm uppercase tracking-widest transition-all duration-300 transform active:scale-[0.98] shadow-[0_0_30px_rgba(16,185,129,0.2)]">
                    Verify Account
                </button>
            </form>

            <div class="mt-10 text-center space-y-4">
                <p class="text-white/40 text-sm font-medium">
                    Didn't receive the code? 
                    <button wire:click="resend" wire:loading.attr="disabled" class="text-emerald-500 hover:text-emerald-400 font-bold transition-colors ml-1 disabled:opacity-50">
                        Resend Code
                    </button>
                </p>
                
                <div class="pt-4 border-t border-white/5">
                    <form action="{{ route('logout') }}" method="POST">
                        @csrf
                        <button type="submit" class="text-white/20 hover:text-white/50 text-[10px] font-bold uppercase tracking-widest transition-all">
                            Back to Login
                        </button>
                    </form>
                </div>
            </div>
        </div>

        {{-- Floating Badge --}}
        <div class="mt-8 bg-blue-600/20 border border-blue-500/30 rounded-full px-6 py-3 backdrop-blur-md animate-bounce-slow">
            <span class="text-blue-400 text-xs font-black uppercase tracking-tighter">Secured by MoneyTrack Guard</span>
        </div>
    </div>

    <style>
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(2deg); }
        }
        .animate-float { animation: float 6s infinite ease-in-out; }
        
        @keyframes float-delayed {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-15px) rotate(-2deg); }
        }
        .animate-float-delayed { animation: float-delayed 8s infinite ease-in-out; }

        @keyframes fade-in-down {
            0% { opacity: 0; transform: translateY(-10px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in-down { animation: fade-in-down 0.6s ease-out; }
        
        @keyframes bounce-slow {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        .animate-bounce-slow { animation: bounce-slow 3s infinite ease-in-out; }

        @keyframes bounce-short {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-5px); }
        }
        .animate-bounce-short { animation: bounce-short 0.5s ease-in-out; }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        .animate-shake { animation: shake 0.2s ease-in-out 3; }
    </style>
</div>
