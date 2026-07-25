<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MutasiApprovalResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'urutan_approval' => $this->urutan_approval,
            'approver_role' => new RoleResource($this->whenLoaded('approverRole')),
            'approver' => new UserResource($this->whenLoaded('approver')),
            'status' => $this->status,
            'catatan' => $this->catatan,
            'tanggal_approval' => $this->tanggal_approval,
        ];
    }
}
