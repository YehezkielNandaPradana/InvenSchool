<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class KategoriDanaResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'kode_dana' => $this->kode_dana,
            'nama_dana' => $this->nama_dana,
        ];
    }
}
