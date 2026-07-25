<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class LaporanKerusakan extends Model
{
    protected $table = 'tbl_laporan_kerusakan';

    protected $fillable = [
        'no_laporan',
        'barang_id',
        'lokasi_id',
        'pelapor_id',
        'jumlah_rusak',
        'deskripsi',
        'status',
        'verifikator_id',
        'tanggal_verifikasi',
        'catatan_verifikasi',
    ];

    public function barang(): BelongsTo
    {
        return $this->belongsTo(Barang::class, 'barang_id');
    }

    public function lokasi(): BelongsTo
    {
        return $this->belongsTo(Lokasi::class, 'lokasi_id');
    }

    public function pelapor(): BelongsTo
    {
        return $this->belongsTo(User::class, 'pelapor_id');
    }

    public function verifikator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'verifikator_id');
    }

    public function lampiran(): HasMany
    {
        return $this->hasMany(LampiranKerusakan::class, 'laporan_id');
    }
}
