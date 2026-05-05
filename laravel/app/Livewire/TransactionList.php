<?php

namespace App\Livewire;

use App\Models\Transaction;
use App\Services\TransactionService;
use Illuminate\Support\Facades\Auth;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;

class TransactionList extends Component
{
    use WithPagination;

    #[On('transaction-saved')]
    public function refresh(): void
    {
        $this->resetPage();
    }

    public string  $search      = '';
    public string  $type        = '';
    public string  $sortField   = 'date';
    public string  $sortOrder   = 'desc';
    public string  $fromDate    = '';
    public string  $toDate      = '';
    public bool    $showModal   = false;

    // Form fields
    public string $fTitle      = '';
    public float  $fAmount     = 0;
    public string $fType       = 'expense';
    public string $fDate       = '';
    public int    $fCategoryId = 0;
    public string $fNote       = '';
    public ?int   $editingId   = null;

    protected $queryString = ['search', 'type', 'sortField', 'sortOrder'];

    protected array $rules = [
        'fTitle'      => 'required|string|max:255',
        'fAmount'     => 'required|numeric|min:1',
        'fType'       => 'required|in:income,expense',
        'fDate'       => 'required|date',
        'fCategoryId' => 'nullable|integer',
        'fNote'       => 'nullable|string|max:500',
    ];

    public function mount(): void
    {
        $this->fDate = now()->toDateString();
    }

    public function updatingSearch(): void  { $this->resetPage(); }
    public function updatingType(): void    { $this->resetPage(); }

    public function sortBy(string $field): void
    {
        $this->sortOrder = ($this->sortField === $field && $this->sortOrder === 'asc')
            ? 'desc' : 'asc';
        $this->sortField = $field;
    }

    public function openModal(?int $editId = null): void
    {
        $this->resetValidation();
        $this->editingId = $editId;

        if ($editId) {
            $tx = Transaction::findOrFail($editId);
            $this->fTitle      = $tx->title;
            $this->fAmount     = (float) $tx->amount;
            $this->fType       = $tx->type;
            $this->fDate       = $tx->date->toDateString();
            $this->fCategoryId = $tx->category_id ?? 0;
            $this->fNote       = $tx->note ?? '';
        } else {
            $this->fTitle      = '';
            $this->fAmount     = 0;
            $this->fType       = 'expense';
            $this->fDate       = now()->toDateString();
            $this->fCategoryId = 0;
            $this->fNote       = '';
        }

        $this->showModal = true;
    }

    public function save(TransactionService $service): void
    {
        $this->validate();
        $userId = Auth::id();
        $data   = [
            'title'       => $this->fTitle,
            'amount'      => $this->fAmount,
            'type'        => $this->fType,
            'date'        => $this->fDate,
            'category_id' => $this->fCategoryId ?: null,
            'note'        => $this->fNote ?: null,
        ];

        if ($this->editingId) {
            $service->update($userId, $this->editingId, $data);
            session()->flash('success', 'Transaksi berhasil diperbarui.');
        } else {
            $service->create($userId, $data);
            session()->flash('success', 'Transaksi berhasil disimpan.');
        }

        $this->showModal = false;
        $this->resetPage();
    }

    public function delete(TransactionService $service, int $id): void
    {
        $service->delete(Auth::id(), $id);
        session()->flash('success', 'Transaksi dihapus.');
    }

    public function render()
    {
        $transactions = Transaction::with('category')
            ->where('user_id', Auth::id())
            ->when($this->search, fn($q) => $q->where('title', 'like', "%{$this->search}%"))
            ->when($this->type,   fn($q) => $q->where('type', $this->type))
            ->when($this->fromDate, fn($q) => $q->whereDate('date', '>=', $this->fromDate))
            ->when($this->toDate,   fn($q) => $q->whereDate('date', '<=', $this->toDate))
            ->orderBy($this->sortField, $this->sortOrder)
            ->paginate(15);

        $categories = \App\Models\Category::where('user_id', Auth::id())->get();

        return view('livewire.transaction-list', compact('transactions', 'categories'))
            ->layout('layouts.app');
    }
}
