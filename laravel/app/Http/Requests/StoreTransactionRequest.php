<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreTransactionRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'title'       => 'required|string|max:255',
            'amount'      => 'required|numeric|min:1|max:999999999',
            'type'        => 'required|in:income,expense',
            'category_id' => 'nullable|integer|exists:categories,id',
            'date'        => 'required|date',
            'note'        => 'nullable|string|max:500',
        ];
    }

    public function messages(): array
    {
        return [
            'amount.min'           => 'Nominal minimal Rp 1.',
            'date.before_or_equal' => 'Tanggal tidak boleh melebihi hari ini.',
        ];
    }
}
