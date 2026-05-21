<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreTransactionRequest;
use App\Http\Requests\UpdateTransactionRequest;
use App\Http\Resources\TransactionResource;
use App\Services\TransactionService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class TransactionController extends Controller
{
    public function __construct(private TransactionService $transactionService) {}

    public function index(Request $request): JsonResponse
    {
        $request->validate([
            'type'        => 'nullable|in:income,expense',
            'category_id' => 'nullable|integer|exists:categories,id',
            'from'        => 'nullable|date',
            'to'          => 'nullable|date|after_or_equal:from',
            'search'      => 'nullable|string|max:100',
            'sort'        => 'nullable|in:date,amount,title',
            'order'       => 'nullable|in:asc,desc',
            'per_page'    => 'nullable|integer|between:5,100',
        ]);

        $transactions = $this->transactionService->paginate(
            userId:     $request->user()->id,
            filters:    $request->only('type', 'category_id', 'from', 'to', 'search'),
            sort:       $request->get('sort',     'date'),
            order:      $request->get('order',    'desc'),
            perPage:    $request->integer('per_page', 15),
        );

        return response()->json([
            'data' => TransactionResource::collection($transactions),
            'meta' => [
                'current_page' => $transactions->currentPage(),
                'last_page'    => $transactions->lastPage(),
                'per_page'     => $transactions->perPage(),
                'total'        => $transactions->total(),
            ],
        ]);
    }

    public function store(StoreTransactionRequest $request): JsonResponse
    {
        $transaction = $this->transactionService->create(
            $request->user()->id,
            $request->validated()
        );

        return response()->json([
            'message' => 'Transaksi berhasil ditambahkan.',
            'data'    => new TransactionResource($transaction),
        ], 201);
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $transaction = $this->transactionService->findForUser($request->user()->id, $id);

        return response()->json(['data' => new TransactionResource($transaction)]);
    }

    public function update(UpdateTransactionRequest $request, int $id): JsonResponse
    {
        $transaction = $this->transactionService->update(
            $request->user()->id,
            $id,
            $request->validated()
        );

        return response()->json([
            'message' => 'Transaksi berhasil diperbarui.',
            'data'    => new TransactionResource($transaction),
        ]);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $this->transactionService->delete($request->user()->id, $id);

        return response()->json(['message' => 'Transaksi berhasil dihapus.']);
    }

    public function exportPdf(Request $request): \Symfony\Component\HttpFoundation\Response
    {
        $request->validate([
            'from' => 'nullable|date',
            'to'   => 'nullable|date',
        ]);

        $pdf = $this->transactionService->generatePdf(
            userId:  $request->user()->id,
            filters: $request->only('from', 'to', 'type', 'category_id'),
        );

        return $pdf->download('moneytrack-laporan-' . now()->format('Y-m-d') . '.pdf');
    }
}
