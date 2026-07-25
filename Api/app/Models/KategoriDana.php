<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class KategoriDana extends Model
{
    protected $table = 'tbl_kategori_dana';

    protected $fillable = [
        'kode_dana',
        'nama_dana',
    ];

    public function barang(): HasMany
    {
        return $this->hasMany(Barang::class, 'kategori_dana_id');
    }

    public function penomoranKode(): HasMany
    {
        return $this->hasMany(PenomoranKode::class, 'kategori_dana_id');
    }
}
