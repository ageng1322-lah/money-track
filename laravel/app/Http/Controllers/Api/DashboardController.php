<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionResource;
use App\Services\DashboardService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function __construct(private DashboardService $dashboardService) {}

    public function index(Request $request): JsonResponse
    {
        $request->validate([
            'month' => 'nullable|integer|between:1,12',
            'year'  => 'nullable|integer|min:2020',
        ]);

        $user  = $request->user();
        $month = $request->integer('month', now()->month);
        $year  = $request->integer('year',  now()->year);

        $summary    = $this->dashboardService->getMonthlySummary($user->id, $month, $year);
        $chartData  = $this->dashboardService->getBarChartData($user->id, $year);
        $recent     = $this->dashboardService->getRecentTransactions($user->id, 5);

        return response()->json([
            'summary'    => $summary,
            'chart_data' => $chartData,
            'recent'     => TransactionResource::collection($recent),
        ]);
    }
}
