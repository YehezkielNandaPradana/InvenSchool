<?php

namespace App\Policies;

use App\Models\User;

class BarangPolicy
{
    public function viewAny(User $user): bool
    {
        return true;
    }

    public function view(User $user, $barang): bool
    {
        return true;
    }

    public function create(User $user): bool
    {
        return in_array($user?->role?->kode_role, ['KATU', 'SARPRAS']);
    }

    public function update(User $user, $barang): bool
    {
        return in_array($user?->role?->kode_role, ['KATU', 'SARPRAS']);
    }

    public function delete(User $user, $barang): bool
    {
        return $user?->role?->kode_role === 'KATU';
    }
}
