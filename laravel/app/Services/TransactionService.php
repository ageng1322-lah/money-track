<?php

namespace App\Services;

use App\Models\Transaction;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class TransactionService
{
    public function __construct(private DashboardService $dashboardService) {}

    public function paginate(
        int    $userId,
        array  $filters  = [],
        string $sort     = 'date',
        string $order    = 'desc',
        int    $perPage  = 15,
    ): LengthAwarePaginator {
        $allowedSorts = ['date', 'amount', 'title', 'created_at'];
        $sort         = in_array($sort, $allowedSorts) ? $sort : 'date';
        $order        = in_array($order, ['asc', 'desc']) ? $order : 'desc';

        return Transaction::with('category')
            ->where('user_id', $userId)
            ->when($filters['type']        ?? null, fn($q, $v) => $q->where('type', $v))
            ->when($filters['category_id'] ?? null, fn($q, $v) => $q->where('category_id', $v))
            ->when($filters['from']        ?? null, fn($q, $v) => $q->whereDate('date', '>=', $v))
            ->when($filters['to']          ?? null, fn($q, $v) => $q->whereDate('date', '<=', $v))
            ->when($filters['search']      ?? null, fn($q, $v) => $q->where('title', 'like', "%{$v}%"))
            ->orderBy($sort, $order)
            ->paginate($perPage);
    }

    public function create(int $userId, array $data): Transaction
    {
        $transaction = Transaction::create(array_merge($data, ['user_id' => $userId]));
        $this->dashboardService->clearCache($userId);
        return $transaction->load('category');
    }

    public function findForUser(int $userId, int $id): Transaction
    {
        return Transaction::with('category')
            ->where('user_id', $userId)
            ->findOrFail($id);
    }

    public function update(int $userId, int $id, array $data): Transaction
    {
        $transaction = $this->findForUser($userId, $id);
        $transaction->update($data);
        $this->dashboardService->clearCache($userId);
        return $transaction->fresh('category');
    }

    public function delete(int $userId, int $id): void
    {
        $transaction = $this->findForUser($userId, $id);
        $transaction->delete();
        $this->dashboardService->clearCache($userId);
    }

    public function generatePdf(int $userId, array $filters = [])
    {
        $transactions = Transaction::with('category')
            ->where('user_id', $userId)
            ->when($filters['type']        ?? null, fn($q, $v) => $q->where('type', $v))
            ->when($filters['category_id'] ?? null, fn($q, $v) => $q->where('category_id', $v))
            ->when($filters['from']        ?? null, fn($q, $v) => $q->whereDate('date', '>=', $v))
            ->when($filters['to']          ?? null, fn($q, $v) => $q->whereDate('date', '<=', $v))
            ->orderByDesc('date')
            ->get();

        $totalIncome  = $transactions->where('type', 'income')->sum('amount');
        $totalExpense = $transactions->where('type', 'expense')->sum('amount');

        return Pdf::loadView('pdf.transactions', compact(
            'transactions', 'totalIncome', 'totalExpense', 'filters'
        ))->setPaper('a4', 'portrait');
    }
}
