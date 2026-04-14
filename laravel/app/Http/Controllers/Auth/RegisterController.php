<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class RegisterController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'name'     => ['required', 'string', 'max:255'],
            'email'    => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'confirmed', Password::min(8)],
        ]);

        $user = User::create([
            'name'     => $request->name,
            'email'    => $request->email,
            'password' => Hash::make($request->password),
        ]);

        // Seed default categories
        $this->seedDefaultCategories($user->id);

        Auth::login($user);

        return redirect('/dashboard');
    }

    private function seedDefaultCategories(int $userId): void
    {
        $defaults = [
            ['name' => 'Gaji',       'icon' => '💼', 'type' => 'income',  'color' => '#1D9E75'],
            ['name' => 'Freelance',  'icon' => '💻', 'type' => 'income',  'color' => '#0F6E56'],
            ['name' => 'Investasi',  'icon' => '📈', 'type' => 'income',  'color' => '#639922'],
            ['name' => 'Makanan',    'icon' => '🍔', 'type' => 'expense', 'color' => '#E24B4A'],
            ['name' => 'Transport',  'icon' => '🚗', 'type' => 'expense', 'color' => '#D85A30'],
            ['name' => 'Belanja',    'icon' => '🛍️', 'type' => 'expense', 'color' => '#D4537E'],
            ['name' => 'Kesehatan',  'icon' => '💊', 'type' => 'expense', 'color' => '#378ADD'],
            ['name' => 'Hiburan',    'icon' => '🎮', 'type' => 'expense', 'color' => '#7F77DD'],
            ['name' => 'Tagihan',    'icon' => '📄', 'type' => 'expense', 'color' => '#BA7517'],
        ];

        foreach ($defaults as $cat) {
            Category::create(array_merge($cat, [
                'user_id'    => $userId,
                'is_default' => true,
            ]));
        }
    }
}
