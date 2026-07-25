<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BarangResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'kode_barang' => $this->kode_barang,
            'nama_barang' => $this->nama_barang,
            'spesifikasi' => $this->spesifikasi,
            'stok_baik' => $this->stok_baik,
            'stok_rusak' => $this->stok_rusak,
            'stok_total' => $this->stok_total,
            'kondisi_umum' => $this->kondisi_umum,
            'status_aktif' => $this->status_aktif,
            'kategori_dana' => new KategoriDanaResource($this->whenLoaded('kategoriDana')),
            'kategori_barang' => new KategoriBarangResource($this->whenLoaded('kategoriBarang')),
            'lokasi' => new LokasiResource($this->whenLoaded('lokasi')),
            'created_by' => new UserResource($this->whenLoaded('createdBy')),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
