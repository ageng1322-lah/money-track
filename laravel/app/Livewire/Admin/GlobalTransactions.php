<?php

namespace App\Livewire\Admin;

use Livewire\Component;
use App\Models\Transaction;
use Livewire\WithPagination;

class GlobalTransactions extends Component
{
    use WithPagination;

    public $search = '';

    public function updatingSearch()
    {
        $this->resetPage();
    }

    public function deleteTransaction($id)
    {
        $transaction = Transaction::find($id);
        if ($transaction) {
            $transaction->delete();
            session()->flash('message', 'Transaction deleted successfully.');
        }
    }

    public function render()
    {
        $transactions = Transaction::with('user', 'category')
            ->whereHas('user', function($query) {
                $query->where('name', 'like', '%' . $this->search . '%');
            })
            ->orWhere('note', 'like', '%' . $this->search . '%')
            ->orderBy('date', 'desc')
            ->paginate(15);

        return view('livewire.admin.global-transactions', [
            'transactions' => $transactions
        ])->layout('layouts.admin');
    }
}
