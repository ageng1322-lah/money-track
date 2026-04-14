{{-- resources/views/profile.blade.php --}}
<x-layouts.app>
    <div class="max-w-2xl mx-auto">
        <div class="bg-white rounded-2xl border border-gray-100 p-8">
            <h1 class="text-2xl font-bold text-gray-900 mb-6">Profil Saya</h1>

            <div class="space-y-6">
                <div class="flex items-center gap-6 pb-6 border-b border-gray-50">
                    <div class="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center text-green-700 font-bold text-2xl">
                        {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                    </div>
                    <div>
                        <p class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Nama Lengkap</p>
                        <p class="text-lg font-bold text-gray-800">{{ Auth::user()->name }}</p>
                    </div>
                </div>

                <div>
                    <p class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Alamat Email</p>
                    <p class="text-lg font-bold text-gray-800">{{ Auth::user()->email }}</p>
                </div>

                <div>
                    <p class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Member Sejak</p>
                    <p class="text-lg font-bold text-gray-800">{{ Auth::user()->created_at->format('d F Y') }}</p>
                </div>

                <div class="pt-6">
                    <button class="px-6 py-2 bg-gray-100 text-gray-600 rounded-lg text-sm font-semibold hover:bg-gray-200 transition">
                        Edit Profil
                    </button>
                    <button class="px-6 py-2 text-red-500 text-sm font-semibold hover:underline ml-4">
                        Hapus Akun
                    </button>
                </div>
            </div>
        </div>
    </div>
</x-layouts.app>
