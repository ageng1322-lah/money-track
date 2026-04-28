<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Transaction;
use App\Models\Category;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index()
    {
        $stats = [
            'total_users' => User::count(),
            'total_transactions' => Transaction::count(),
            'total_categories' => Category::count(),
        ];

        return view('admin.dashboard', compact('stats'));
    }
}
