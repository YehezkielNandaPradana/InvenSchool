<?php

namespace App\Policies;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;

class MasterDataPolicy
{
    public function viewAny(User $user): bool
    {
        return true;
    }

    public function view(User $user, Model $model): bool
    {
        return true;
    }

    public function create(User $user): bool
    {
        return $user?->role?->kode_role === 'KATU';
    }

    public function update(User $user, Model $model): bool
    {
        return $user?->role?->kode_role === 'KATU';
    }

    public function delete(User $user, Model $model): bool
    {
        return $user?->role?->kode_role === 'KATU';
    }
}
