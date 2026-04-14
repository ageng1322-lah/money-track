{{-- resources/views/auth/register.blade.php --}}
<!DOCTYPE html>
<html lang="id" class="h-full bg-white">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Akun — FinTrack</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body class="h-full">
    <div class="flex min-h-full">
        {{-- Form --}}
        <div class="flex flex-1 flex-col justify-center px-6 py-12 lg:flex-none lg:px-20 xl:px-24">
            <div class="mx-auto w-full max-w-sm lg:w-96">
                <div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-green-600 text-2xl font-black text-white">₿</div>
                    <h2 class="mt-8 text-3xl font-extrabold tracking-tight text-gray-900">Mulai langkah finansial Anda</h2>
                    <p class="mt-2 text-sm text-gray-500">
                        Sudah punya akun?
                        <a href="{{ route('login') }}" class="font-semibold text-green-600 hover:text-green-500">Masuk ke akun</a>
                    </p>
                </div>

                <div class="mt-10">
                    <form action="{{ route('register') }}" method="POST" class="space-y-6">
                        @csrf
                        <div>
                            <label for="name" class="block text-sm font-medium leading-6 text-gray-900">Nama Lengkap</label>
                            <div class="mt-2">
                                <input id="name" name="name" type="text" required value="{{ old('name') }}"
                                    class="block w-full rounded-xl border-0 py-2.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-green-600 sm:text-sm sm:leading-6">
                            </div>
                            @error('name') <p class="mt-1 text-xs text-red-500">{{ $message }}</p> @enderror
                        </div>

                        <div>
                            <label for="email" class="block text-sm font-medium leading-6 text-gray-900">Alamat Email</label>
                            <div class="mt-2">
                                <input id="email" name="email" type="email" autocomplete="email" required value="{{ old('email') }}"
                                    class="block w-full rounded-xl border-0 py-2.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-green-600 sm:text-sm sm:leading-6">
                            </div>
                            @error('email') <p class="mt-1 text-xs text-red-500">{{ $message }}</p> @enderror
                        </div>

                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label for="password" class="block text-sm font-medium leading-6 text-gray-900">Password</label>
                                <div class="mt-2">
                                    <input id="password" name="password" type="password" required
                                        class="block w-full rounded-xl border-0 py-2.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-green-600 sm:text-sm sm:leading-6">
                                </div>
                                @error('password') <p class="mt-1 text-xs text-red-500">{{ $message }}</p> @enderror
                            </div>
                            <div>
                                <label for="password_confirmation" class="block text-sm font-medium leading-6 text-gray-900">Konfirmasi</label>
                                <div class="mt-2">
                                    <input id="password_confirmation" name="password_confirmation" type="password" required
                                        class="block w-full rounded-xl border-0 py-2.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-green-600 sm:text-sm sm:leading-6">
                                </div>
                            </div>
                        </div>

                        <div class="flex items-center">
                            <input id="terms" name="terms" type="checkbox" required class="h-4 w-4 rounded border-gray-300 text-green-600 focus:ring-green-600">
                            <label for="terms" class="ml-3 block text-sm leading-6 text-gray-700">
                                Saya setuju dengan <a href="#" class="font-semibold text-green-600">Ketentuan Layanan</a>
                            </label>
                        </div>

                        <div>
                            <button type="submit"
                                class="flex w-full justify-center rounded-xl bg-green-600 px-3 py-3 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-green-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-600 transition-all active:scale-[0.98]">
                                Buat Akun Sekarang
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        {{-- Visual Side --}}
        <div class="relative hidden w-0 flex-1 lg:block border-l border-gray-100 bg-gray-50">
             <div class="absolute inset-0 flex items-center justify-center p-12">
                <div class="max-w-lg">
                    <div class="grid grid-cols-2 gap-4 mb-8">
                        <div class="h-32 rounded-2xl bg-green-600/10 border border-green-600/20 p-4 flex flex-col justify-between">
                            <div class="w-8 h-8 rounded-lg bg-green-600 flex items-center justify-center text-white">↑</div>
                            <div>
                                <p class="text-xs text-green-800 font-medium">Income</p>
                                <p class="text-xl font-bold text-green-900">Rp 12,5 jt</p>
                            </div>
                        </div>
                        <div class="h-32 rounded-2xl bg-red-600/10 border border-red-600/20 p-4 flex flex-col justify-between">
                            <div class="w-8 h-8 rounded-lg bg-red-600 flex items-center justify-center text-white">↓</div>
                            <div>
                                <p class="text-xs text-red-800 font-medium">Expense</p>
                                <p class="text-xl font-bold text-red-900">Rp 4,2 jt</p>
                            </div>
                        </div>
                    </div>
                    <h1 class="text-4xl font-extrabold tracking-tight text-gray-900">Kelola uang Anda sedetail mungkin.</h1>
                    <p class="mt-6 text-lg text-gray-600 outline-none">Gunakan kategori kustom, ekspor laporan ke PDF, dan buat perencanaan belanja yang lebih matang setiap bulannya.</p>
                </div>
             </div>
        </div>
    </div>
</body>
</html>
