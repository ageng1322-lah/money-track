<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\Category;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class AuthController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name'     => 'required|string|max:255',
            'email'    => 'required|email|unique:users',
            'password' => ['required', 'confirmed', Password::min(8)],
        ]);

        $user = User::create($validated);

        // Seed default categories for new user
        $this->seedDefaultCategories($user->id);

        $token = $user->createToken('fintrack-mobile')->plainTextToken;

        return response()->json([
            'message' => 'Registrasi berhasil.',
            'token'   => $token,
            'user'    => new UserResource($user),
        ], 201);
    }

    public function login(Request $request): JsonResponse
    {
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json([
                'message' => 'Email atau password salah.',
            ], 401);
        }

        $user  = Auth::user();
        $token = $user->createToken('fintrack-mobile')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil.',
            'token'   => $token,
            'user'    => new UserResource($user),
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logout berhasil.']);
    }

    public function me(Request $request): JsonResponse
    {
        return response()->json(new UserResource($request->user()));
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
