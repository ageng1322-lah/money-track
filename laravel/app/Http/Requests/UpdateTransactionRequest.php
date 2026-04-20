<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateTransactionRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'title'       => 'sometimes|required|string|max:255',
            'amount'      => 'sometimes|required|numeric|min:1|max:999999999',
            'type'        => 'sometimes|required|in:income,expense',
            'category_id' => 'nullable|integer|exists:categories,id',
            'date'        => 'sometimes|required|date',
            'note'        => 'nullable|string|max:500',
        ];
    }
}
