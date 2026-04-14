<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $categories = Category::where('user_id', $request->user()->id)
            ->when($request->type, fn($q) => $q->whereIn('type', [$request->type, 'both']))
            ->orderBy('name')
            ->get();

        return response()->json(['data' => $categories]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name'  => 'required|string|max:100',
            'icon'  => 'nullable|string|max:10',
            'type'  => 'required|in:income,expense,both',
            'color' => 'nullable|string|regex:/^#[0-9A-Fa-f]{6}$/',
        ]);

        $category = Category::create(array_merge($validated, [
            'user_id' => $request->user()->id,
        ]));

        return response()->json([
            'message' => 'Kategori berhasil ditambahkan.',
            'data'    => $category,
        ], 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $category = Category::where('user_id', $request->user()->id)
            ->findOrFail($id);

        $validated = $request->validate([
            'name'  => 'sometimes|required|string|max:100',
            'icon'  => 'nullable|string|max:10',
            'type'  => 'sometimes|required|in:income,expense,both',
            'color' => 'nullable|string|regex:/^#[0-9A-Fa-f]{6}$/',
        ]);

        $category->update($validated);

        return response()->json([
            'message' => 'Kategori berhasil diperbarui.',
            'data'    => $category,
        ]);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $category = Category::where('user_id', $request->user()->id)
            ->findOrFail($id);

        if ($category->is_default) {
            return response()->json(['message' => 'Kategori default tidak bisa dihapus.'], 422);
        }

        $category->delete();

        return response()->json(['message' => 'Kategori berhasil dihapus.']);
    }
}
