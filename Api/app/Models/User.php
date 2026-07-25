<?php

namespace App\Models;

use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Spatie\Permission\Traits\HasRoles;

#[Fillable([
    'nip_nik',
    'username',
    'name',
    'email',
    'password',
    'role_id',
    'lokasi_id',
    'status_aktif',
])]
#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasFactory, Notifiable, HasRoles;

    protected $table = 'tbl_users';

    protected function casts(): array
    {
        return [
            'password' => 'hashed',
        ];
    }

    public function role(): BelongsTo
    {
        return $this->belongsTo(Role::class, 'role_id');
    }

    public function lokasi(): BelongsTo
    {
        return $this->belongsTo(Lokasi::class, 'lokasi_id');
    }

    public function barangCreated(): HasMany
    {
        return $this->hasMany(Barang::class, 'created_by');
    }

    public function mutasiPengajuan(): HasMany
    {
        return $this->hasMany(MutasiBarang::class, 'pengaju_id');
    }

    public function laporanPelapor(): HasMany
    {
        return $this->hasMany(LaporanKerusakan::class, 'pelapor_id');
    }

    public function laporanVerifikator(): HasMany
    {
        return $this->hasMany(LaporanKerusakan::class, 'verifikator_id');
    }

    public function mutasiApprovals(): HasMany
    {
        return $this->hasMany(MutasiApproval::class, 'approver_id');
    }

    public function logAktivitas(): HasMany
    {
        return $this->hasMany(LogAktivitas::class, 'user_id');
    }
}
