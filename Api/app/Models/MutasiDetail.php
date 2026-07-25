<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MutasiDetail extends Model
{
    protected $table = 'tbl_mutasi_detail';

    public $timestamps = false;

    protected $fillable = [
        'mutasi_id',
        'barang_id',
        'jumlah',
    ];

    public function mutasi(): BelongsTo
    {
        return $this->belongsTo(MutasiBarang::class, 'mutasi_id');
    }

    public function barang(): BelongsTo
    {
        return $this->belongsTo(Barang::class, 'barang_id');
    }
}
