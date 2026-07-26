<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KondisiRusak extends Model
{
    protected $table = 'kondisi_rusak';

    protected $fillable = [
        'barang_id',
        'deskripsi',
        'tingkat_kerusakan',
        'tanggal_dicatat',
        'status',
    ];

    public function barang()
    {
        return $this->belongsTo(Barang::class);
    }
}
