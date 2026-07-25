<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MutasiDetailResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'barang' => new BarangResource($this->whenLoaded('barang')),
            'jumlah' => $this->jumlah,
        ];
    }
}
