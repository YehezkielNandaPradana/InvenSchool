<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AuditStokResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'jenis_transaksi' => $this->jenis_transaksi,
            'referensi_tabel' => $this->referensi_tabel,
            'referensi_id' => $this->referensi_id,
            'stok_sebelum' => $this->stok_sebelum,
            'stok_sesudah' => $this->stok_sesudah,
            'jumlah_perubahan' => $this->jumlah_perubahan,
            'created_at' => $this->created_at,
        ];
    }
}
