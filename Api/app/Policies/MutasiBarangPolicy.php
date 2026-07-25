<?php

namespace App\Policies;

use App\Models\MutasiBarang;
use App\Models\User;

class MutasiBarangPolicy
{
    public function viewAny(User $user): bool
    {
        return true;
    }

    public function view(User $user, MutasiBarang $mutasi): bool
    {
        return true;
    }

    public function create(User $user): bool
    {
        return in_array($user?->role?->kode_role, ['KAPRODI', 'KATU']);
    }

    private function canModify(User $user, MutasiBarang $mutasi): bool
    {
        return $mutasi->status === 'Draft'
            && in_array($user?->role?->kode_role, ['KAPRODI', 'KATU'])
            && ($user?->role?->kode_role !== 'KAPRODI' || $mutasi->pengaju_id === $user->id);
    }

    public function addDetail(User $user, MutasiBarang $mutasi): bool
    {
        return $this->canModify($user, $mutasi);
    }

    public function removeDetail(User $user, MutasiBarang $mutasi): bool
    {
        return $this->canModify($user, $mutasi);
    }

    public function ajukan(User $user, MutasiBarang $mutasi): bool
    {
        return $user?->role?->kode_role === 'KAPRODI' && $mutasi->pengaju_id === $user->id;
    }

    public function verifikasiSarpras(User $user, MutasiBarang $mutasi): bool
    {
        return $user?->role?->kode_role === 'SARPRAS';
    }

    public function approvalKepsek(User $user, MutasiBarang $mutasi): bool
    {
        return $user?->role?->kode_role === 'KEPSEK';
    }
}
