<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Lokasi extends Model
{
    protected $table = 'tbl_lokasi';

    protected $fillable = [
        'kode_lokasi',
        'nama_lokasi',
        'jenis_lokasi',
    ];

    public function users(): HasMany
    {
        return $this->hasMany(User::class, 'lokasi_id');
    }

    public function barang(): HasMany
    {
        return $this->hasMany(Barang::class, 'lokasi_id');
    }

    public function mutasiAsal(): HasMany
    {
        return $this->hasMany(MutasiBarang::class, 'lokasi_asal_id');
    }

    public function mutasiTujuan(): HasMany
    {
        return $this->hasMany(MutasiBarang::class, 'lokasi_tujuan_id');
    }

    public function laporanKerusakan(): HasMany
    {
        return $this->hasMany(LaporanKerusakan::class, 'lokasi_id');
    }

    public function penomoranKode(): HasMany
    {
        return $this->hasMany(PenomoranKode::class, 'lokasi_id');
    }
}
