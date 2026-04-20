<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\TransactionController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| FinTrack API Routes — v1
|--------------------------------------------------------------------------
*/

// Public routes
Route::prefix('v1')->group(function () {

    // Authentication
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login',    [AuthController::class, 'login']);

    // Protected routes
    Route::middleware('auth:sanctum')->group(function () {

        // Auth
        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('me',      [AuthController::class, 'me']);

        // Dashboard
        Route::get('dashboard', [DashboardController::class, 'index']);

        // Transactions
        Route::prefix('transactions')->group(function () {
            Route::get('/',           [TransactionController::class, 'index']);
            Route::post('/',          [TransactionController::class, 'store']);
            Route::get('export-pdf',  [TransactionController::class, 'exportPdf']);
            Route::get('/{id}',       [TransactionController::class, 'show']);
            Route::put('/{id}',       [TransactionController::class, 'update']);
            Route::delete('/{id}',    [TransactionController::class, 'destroy']);
        });

        // Categories
        Route::apiResource('categories', CategoryController::class)->except(['show']);

        // Profile
        Route::prefix('profile')->group(function () {
            Route::get('/',        [ProfileController::class, 'show']);
            Route::put('/',        [ProfileController::class, 'update']);
            Route::put('/password',[ProfileController::class, 'updatePassword']);
            Route::post('/photo',  [ProfileController::class, 'updatePhoto']);
            Route::delete('/photo',[ProfileController::class, 'deletePhoto']);
        });
    });
});
