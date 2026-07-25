<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PenomoranKode extends Model
{
    protected $table = 'tbl_penomoran_kode';

    protected $fillable = [
        'kategori_dana_id',
        'lokasi_id',
        'nomor_terakhir',
    ];

    public function kategoriDana(): BelongsTo
    {
        return $this->belongsTo(KategoriDana::class, 'kategori_dana_id');
    }

    public function lokasi(): BelongsTo
    {
        return $this->belongsTo(Lokasi::class, 'lokasi_id');
    }
}
