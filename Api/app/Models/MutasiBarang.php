<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class MutasiBarang extends Model
{
    protected $table = 'tbl_mutasi_barang';

    protected $fillable = [
        'no_mutasi',
        'pengaju_id',
        'lokasi_asal_id',
        'lokasi_tujuan_id',
        'keterangan',
        'butuh_approval_kepsek',
        'status',
    ];

    public function pengaju(): BelongsTo
    {
        return $this->belongsTo(User::class, 'pengaju_id');
    }

    public function lokasiAsal(): BelongsTo
    {
        return $this->belongsTo(Lokasi::class, 'lokasi_asal_id');
    }

    public function lokasiTujuan(): BelongsTo
    {
        return $this->belongsTo(Lokasi::class, 'lokasi_tujuan_id');
    }

    public function details(): HasMany
    {
        return $this->hasMany(MutasiDetail::class, 'mutasi_id');
    }

    public function approvals(): HasMany
    {
        return $this->hasMany(MutasiApproval::class, 'mutasi_id');
    }
}
