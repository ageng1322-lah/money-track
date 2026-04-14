{{-- resources/views/auth/login.blade.php --}}
<!DOCTYPE html>
<html lang="id" class="h-full bg-white">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masuk — FinTrack</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body class="h-full">
    <div class="flex min-h-full">
        {{-- Left: Form --}}
        <div class="flex flex-1 flex-col justify-center px-6 py-12 lg:flex-none lg:px-20 xl:px-24">
            <div class="mx-auto w-full max-w-sm lg:w-96">
                <div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-green-600 text-2xl font-black text-white">₿</div>
                    <h2 class="mt-8 text-3xl font-extrabold tracking-tight text-gray-900">Selamat datang kembali</h2>
                    <p class="mt-2 text-sm text-gray-500">
                        Belum punya akun?
                        <a href="{{ route('register') }}" class="font-semibold text-green-600 hover:text-green-500">Daftar sekarang gratis</a>
                    </p>
                </div>

                <div class="mt-10">
                    <form action="{{ route('login') }}" method="POST" class="space-y-6">
                        @csrf
                        <div>
                            <label for="email" class="block text-sm font-medium leading-6 text-gray-900">Alamat Email</label>
                            <div class="mt-2">
                                <input id="email" name="email" type="email" autocomplete="email" required
                                    class="block w-full rounded-xl border-0 py-2.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-green-600 sm:text-sm sm:leading-6">
                            </div>
                            @error('email') <p class="mt-1 text-xs text-red-500">{{ $message }}</p> @enderror
                        </div>

                        <div>
                            <div class="flex items-center justify-between">
                                <label for="password" class="block text-sm font-medium leading-6 text-gray-900">Password</label>
                                <div class="text-sm">
                                    <a href="#" class="font-semibold text-green-600 hover:text-green-500">Lupa password?</a>
                                </div>
                            </div>
                            <div class="mt-2 text-gray-400 relative">
                                <input id="password" name="password" type="password" required
                                    class="block w-full rounded-xl border-0 py-2.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-green-600 sm:text-sm sm:leading-6">
                            </div>
                            @error('password') <p class="mt-1 text-xs text-red-500">{{ $message }}</p> @enderror
                        </div>

                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <input id="remember-me" name="remember-me" type="checkbox" class="h-4 w-4 rounded border-gray-300 text-green-600 focus:ring-green-600">
                                <label for="remember-me" class="ml-3 block text-sm leading-6 text-gray-700">Ingat saya</label>
                            </div>
                        </div>

                        <div>
                            <button type="submit"
                                class="flex w-full justify-center rounded-xl bg-green-600 px-3 py-3 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-green-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-600 transition-all active:scale-[0.98]">
                                Masuk ke Akun
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        {{-- Right: Visual --}}
        <div class="relative hidden w-0 flex-1 lg:block bg-gray-50">
             <div class="absolute inset-0 flex items-center justify-center p-12">
                <div class="max-w-lg text-center">
                    <div class="inline-flex items-center rounded-full bg-green-100 px-3 py-1 text-sm font-medium text-green-700 ring-1 ring-inset ring-green-600/20 mb-6">
                        FinTrack — Smart Finance
                    </div>
                    <h1 class="text-4xl font-extrabold tracking-tight text-gray-900 sm:text-5xl">Monitor keuangan Anda dengan lebih mudah.</h1>
                    <p class="mt-6 text-lg leading-8 text-gray-600">Catat setiap pengeluaran dan pemasukan, pantau statistik bulanan, dan capai tujuan finansial Anda bersama FinTrack.</p>
                </div>
             </div>
             {{-- Abstract background shapes --}}
             <div class="absolute inset-0 -z-10 overflow-hidden" aria-hidden="true">
                <svg class="absolute left-[50%] top-0 h-[48rem] w-[84rem] -translate-x-[50%]" viewBox="0 0 1152 813">
                    <path fill="url(#pattern)" fill-opacity=".3" d="M312.1 232.8L0 812.8H1152L839.9 232.8L576 496.8L312.1 232.8Z" />
                    <defs>
                        <linearGradient id="pattern" x1="576" x2="576" y1="232.8" y2="812.8" gradientUnits="userSpaceOnUse">
                            <stop stop-color="#16a34a" />
                            <stop offset="1" stop-color="#16a34a" stop-opacity="0" />
                        </linearGradient>
                    </defs>
                </svg>
             </div>
        </div>
    </div>
</body>
</html>
