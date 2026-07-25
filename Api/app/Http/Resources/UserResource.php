<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nip_nik' => $this->nip_nik,
            'username' => $this->username,
            'name' => $this->name,
            'email' => $this->email,
            'role' => new RoleResource($this->whenLoaded('role')),
            'lokasi' => new LokasiResource($this->whenLoaded('lokasi')),
            'status_aktif' => $this->status_aktif,
        ];
    }
}
