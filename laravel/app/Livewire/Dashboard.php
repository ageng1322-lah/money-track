<?php

namespace App\Livewire;

use App\Models\Transaction;
use App\Services\DashboardService;
use Illuminate\Support\Facades\Auth;
use Livewire\Attributes\On;
use Livewire\Component;

class Dashboard extends Component
{
    public int    $month;
    public int    $year;
    public float  $totalIncome  = 0;
    public float  $totalExpense = 0;
    public float  $balance      = 0;
    public array  $chartData    = [];
    public array  $recent       = [];

    protected DashboardService $dashboardService;

    public function boot(DashboardService $dashboardService): void
    {
        $this->dashboardService = $dashboardService;
    }

    public function mount(): void
    {
        $this->month = now()->month;
        $this->year  = now()->year;
        $this->loadData();
    }

    public function updatedMonth(): void { $this->loadData(); }
    public function updatedYear(): void  { $this->loadData(); }

    #[On('transaction-saved')]
    public function loadData(): void
    {
        $userId  = Auth::id();
        $this->dashboardService->clearCache($userId, $this->month, $this->year);
        
        $summary = $this->dashboardService->getMonthlySummary($userId, $this->month, $this->year);

        $this->totalIncome  = $summary['total_income'];
        $this->totalExpense = $summary['total_expense'];
        $this->balance      = $summary['balance'];
        $this->chartData    = $this->dashboardService->getBarChartData($userId, $this->year);
        $this->recent       = $this->dashboardService
            ->getRecentTransactions($userId, 5)
            ->toArray();

        $this->dispatch('chartUpdated', $this->chartData);
    }

    public function render()
    {
        return view('livewire.dashboard')->layout('layouts.app');
    }
}
