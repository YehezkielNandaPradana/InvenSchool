<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MutasiBarangResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'no_mutasi' => $this->no_mutasi,
            'pengaju' => new UserResource($this->whenLoaded('pengaju')),
            'lokasi_asal' => new LokasiResource($this->whenLoaded('lokasiAsal')),
            'lokasi_tujuan' => new LokasiResource($this->whenLoaded('lokasiTujuan')),
            'keterangan' => $this->keterangan,
            'butuh_approval_kepsek' => $this->butuh_approval_kepsek,
            'status' => $this->status,
            'details' => MutasiDetailResource::collection($this->whenLoaded('details')),
            'approvals' => MutasiApprovalResource::collection($this->whenLoaded('approvals')),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
