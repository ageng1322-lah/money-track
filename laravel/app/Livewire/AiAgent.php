<?php

namespace App\Livewire;

use Livewire\Attributes\On;
use Livewire\Component;
use App\Services\AiAgentService;
use App\Models\Transaction;
use App\Models\Category;
use Illuminate\Support\Facades\Auth;

class AiAgent extends Component
{
    public $messages = [];
    public $input = '';
    public $isLoading = false;

    public function mount()
    {
        $this->messages[] = [
            'role' => 'ai',
            'content' => 'Halo! Saya AI Agent. Ada yang bisa saya bantu catat hari ini? (Contoh: "Makan bakso 15 ribu" atau "Gaji masuk 5 juta")',
        ];
    }

    public function sendMessage(AiAgentService $aiService)
    {
        if (empty(trim($this->input))) return;

        $userMessage = $this->input;
        $this->messages[] = ['role' => 'user', 'content' => $userMessage];
        $this->input = '';
        $this->isLoading = true;

        // Get user categories for context (names only)
        $userCategories = Category::where('user_id', Auth::id())
            ->orWhere('is_default', true)
            ->pluck('name')
            ->toArray();

        // Call AI Service
        $parsedData = $aiService->parseTransaction($userMessage, $userCategories);

        if (isset($parsedData['error'])) {
            $this->messages[] = ['role' => 'ai', 'content' => 'Maaf, sepertinya ada masalah: ' . $parsedData['error']];
            $this->isLoading = false;
            return;
        }

        // Process Transaction
        $transaction = $this->saveTransaction($parsedData);

        if ($transaction) {
            $formattedAmount = number_format($parsedData['amount'], 0, ',', '.');
            $this->messages[] = [
                'role' => 'ai', 
                'content' => "Sip! Berhasil mencatat **{$parsedData['description']}** sebesar **Rp {$formattedAmount}** ke kategori **" . ($transaction->category->name ?? 'Lainnya') . "**. Apakah ada lagi yang ingin dicatat?",
                'is_success' => true,
                'data' => $parsedData
            ];
            $this->dispatch('transaction-saved');
        } else {
            $this->messages[] = ['role' => 'ai', 'content' => 'Maaf, saya gagal menyimpan transaksi tersebut. Pastikan format pesan Anda jelas.'];
        }

        $this->isLoading = false;
    }

    protected function saveTransaction($data)
    {
        try {
            $userId = Auth::id();
            
            // Search for the best category match
            $categoryName = $data['category'];
            
            // 1. Try exact match for user or default
            $category = Category::where(function($q) use ($userId) {
                    $q->where('user_id', $userId)->orWhere('is_default', true);
                })
                ->where('name', $categoryName)
                ->first();

            // 2. Try partial match if not found
            if (!$category) {
                $category = Category::where(function($q) use ($userId) {
                        $q->where('user_id', $userId)->orWhere('is_default', true);
                    })
                    ->where('name', 'like', "%$categoryName%")
                    ->first();
            }

            // 3. Last fallback to "Lainnya" or "Others"
            if (!$category) {
                $category = Category::where(function($q) use ($userId) {
                        $q->where('user_id', $userId)->orWhere('is_default', true);
                    })
                    ->where('name', 'like', '%Lainnya%')
                    ->first();
            }

            return Transaction::create([
                'user_id' => $userId,
                'category_id' => $category ? $category->id : null,
                'title' => $data['description'],
                'amount' => $data['amount'],
                'type' => $data['type'] ?? 'expense',
                'date' => $data['date'] ?? now()->format('Y-m-d'),
                'note' => 'Dicatat otomatis oleh AI Agent',
            ]);
        } catch (\Exception $e) {
            \Log::error('AiAgent Save Transaction Error: ' . $e->getMessage());
            return null;
        }
    }

    public function render()
    {
        return view('livewire.ai-agent');
    }
}
