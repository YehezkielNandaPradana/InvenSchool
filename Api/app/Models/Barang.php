<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Barang extends Model
{
    protected $table = 'tbl_barang';

    protected $fillable = [
        'kategori_dana_id',
        'kategori_barang_id',
        'lokasi_id',
        'nama_barang',
        'spesifikasi',
        'kondisi_umum',
        'status_aktif',
        'created_by',
    ];

    protected function casts(): array
    {
        return [
            'stok_total' => 'integer',
        ];
    }

    public function kategoriDana(): BelongsTo
    {
        return $this->belongsTo(KategoriDana::class, 'kategori_dana_id');
    }

    public function kategoriBarang(): BelongsTo
    {
        return $this->belongsTo(KategoriBarang::class, 'kategori_barang_id');
    }

    public function lokasi(): BelongsTo
    {
        return $this->belongsTo(Lokasi::class, 'lokasi_id');
    }

    public function barangAsal(): BelongsTo
    {
        return $this->belongsTo(self::class, 'barang_asal_id');
    }

    public function barangTurunan(): HasMany
    {
        return $this->hasMany(self::class, 'barang_asal_id');
    }

    public function createdBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function mutasiDetails(): HasMany
    {
        return $this->hasMany(MutasiDetail::class, 'barang_id');
    }

    public function laporanKerusakan(): HasMany
    {
        return $this->hasMany(LaporanKerusakan::class, 'barang_id');
    }

    public function auditStok(): HasMany
    {
        return $this->hasMany(AuditStok::class, 'barang_id');
    }

    public function scopeLokasiUser($query, User $user)
    {
        if ($user->role?->kode_role === 'KAPRODI' && $user->lokasi_id) {
            return $query->where('lokasi_id', $user->lokasi_id);
        }
        return $query;
    }
}
