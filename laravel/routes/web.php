<?php

use App\Http\Controllers\Api\TransactionController;
use App\Livewire\Dashboard;
use App\Livewire\TransactionList;
use Illuminate\Support\Facades\Route;

// Auth routes (handled by Breeze/Fortify or manual)
Route::middleware('guest')->group(function () {
    Route::view('/login',    'auth.login')->name('login');
    Route::view('/register', 'auth.register')->name('register');
    Route::post('/login',    [\App\Http\Controllers\Auth\LoginController::class,    'login']);
    Route::post('/register', [\App\Http\Controllers\Auth\RegisterController::class, 'register']);
});

// Landing page
Route::get('/', function () {
    return view('landing');
})->name('landing');

// Protected web routes (Livewire)
Route::middleware('auth')->group(function () {
    Route::get('/dashboard',    Dashboard::class)->name('dashboard');
    Route::get('/transactions', TransactionList::class)->name('transactions');
    Route::get('/categories',   \App\Livewire\CategoryList::class)->name('categories');

    // PDF Export (via TransactionController)
    Route::get('/transactions/export-pdf',
        [TransactionController::class, 'exportPdf']
    )->name('transactions.export-pdf');

    Route::get('/profile', [\App\Http\Controllers\ProfileController::class, 'show'])->name('profile');
    Route::put('/profile', [\App\Http\Controllers\ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile/photo', [\App\Http\Controllers\ProfileController::class, 'deletePhoto'])->name('profile.photo.delete');

    Route::post('/logout', function () {
        auth()->logout();
        request()->session()->invalidate();
        request()->session()->regenerateToken();
        return redirect('/login');
    })->name('logout');
});

// Admin routes
Route::middleware(['auth', 'admin'])->prefix('admin')->group(function () {
    Route::get('/dashboard', [\App\Http\Controllers\Admin\DashboardController::class, 'index'])->name('admin.dashboard');
    Route::get('/users', \App\Livewire\Admin\UserManagement::class)->name('admin.users');
    Route::get('/transactions', \App\Livewire\Admin\GlobalTransactions::class)->name('admin.transactions');
    Route::get('/profile', \App\Livewire\Admin\Profile::class)->name('admin.profile');
    
    // Admin category management
    Route::get('/categories', \App\Livewire\Admin\CategoryManagement::class)->name('admin.categories');
});
