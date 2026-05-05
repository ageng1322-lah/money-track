<?php

namespace App\Services;

use App\Models\Transaction;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

class DashboardService
{
    public function getMonthlySummary(int $userId, int $month, int $year): array
    {
        $cacheKey = "dashboard.summary.{$userId}.{$year}.{$month}";

        return Cache::remember($cacheKey, 300, function () use ($userId, $month, $year) {
            // Monthly stats
            $monthlyBase = Transaction::where('user_id', $userId)
                ->whereMonth('date', $month)
                ->whereYear('date',  $year);

            $incomeQuery  = (clone $monthlyBase)->income();
            $expenseQuery = (clone $monthlyBase)->expense();

            $totalIncome  = $incomeQuery->sum('amount');
            $totalExpense = $expenseQuery->sum('amount');
            $incomeCount  = $incomeQuery->count();
            $expenseCount = $expenseQuery->count();
            
            // Global balance (All time)
            $globalIncome = Transaction::where('user_id', $userId)->income()->sum('amount');
            $globalExpense = Transaction::where('user_id', $userId)->expense()->sum('amount');
            $balance = $globalIncome - $globalExpense;

            // Largest income source this month
            $largestIncome = (clone $incomeQuery)
                ->with('category')
                ->orderByDesc('amount')
                ->first();

            // Daily average expense this month
            $daysInMonth = now()->month($month)->year($year)->daysInMonth;
            $dailyAvg = $expenseCount > 0 ? $totalExpense / $daysInMonth : 0;

            return [
                'total_income'   => (float) $totalIncome,
                'total_expense'  => (float) $totalExpense,
                'income_count'   => $incomeCount,
                'expense_count'  => $expenseCount,
                'largest_income' => $largestIncome?->category?->name ?? 'N/A',
                'daily_avg'      => (float) $dailyAvg,
                'balance'        => (float) $balance,
                'month'          => $month,
                'year'           => $year,
            ];
        });
    }

    public function getBarChartData(int $userId, int $year): array
    {
        $cacheKey = "dashboard.chart.{$userId}.{$year}";

        return Cache::remember($cacheKey, 300, function () use ($userId, $year) {
            $months = Transaction::where('user_id', $userId)
                ->whereYear('date', $year)
                ->select(
                    DB::raw('MONTH(date) as month'),
                    DB::raw('SUM(CASE WHEN type = "income" THEN amount ELSE 0 END) as income'),
                    DB::raw('SUM(CASE WHEN type = "expense" THEN amount ELSE 0 END) as expense')
                )
                ->groupBy(DB::raw('MONTH(date)'))
                ->orderBy('month')
                ->get()
                ->keyBy('month');

            return collect(range(1, 12))->map(function ($m) use ($months) {
                $row = $months->get($m);
                return [
                    'month'   => $m,
                    'label'   => now()->month($m)->format('M'),
                    'income'  => (float) ($row?->income  ?? 0),
                    'expense' => (float) ($row?->expense ?? 0),
                ];
            })->values()->all();
        });
    }

    public function getRecentTransactions(int $userId, int $limit = 5): Collection
    {
        return Transaction::with('category')
            ->where('user_id', $userId)
            ->orderByDesc('date')
            ->orderByDesc('created_at')
            ->limit($limit)
            ->get();
    }

    public function clearCache(int $userId, ?int $month = null, ?int $year = null): void
    {
        $month = $month ?? now()->month;
        $year  = $year  ?? now()->year;

        Cache::forget("dashboard.summary.{$userId}.{$year}.{$month}");
        Cache::forget("dashboard.chart.{$userId}.{$year}");
    }
}
