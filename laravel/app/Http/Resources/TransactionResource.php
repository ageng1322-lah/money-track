<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TransactionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'          => $this->id,
            'title'       => $this->title,
            'amount'      => (float) $this->amount,
            'type'        => $this->type,
            'date'        => $this->date->toDateString(),
            'note'        => $this->note,
            'category'    => $this->whenLoaded('category', fn() => [
                'id'    => $this->category?->id,
                'name'  => $this->category?->name,
                'icon'  => $this->category?->icon,
                'color' => $this->category?->color,
                'type'  => $this->category?->type,
            ]),
            'created_at'  => $this->created_at->toDateTimeString(),
        ];
    }
}
