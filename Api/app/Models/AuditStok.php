<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AuditStok extends Model
{
    protected $table = 'tbl_audit_stok';

    public $timestamps = false;

    protected $fillable = [
        'barang_id',
        'jenis_transaksi',
        'referensi_tabel',
        'referensi_id',
        'stok_sebelum',
        'stok_sesudah',
        'jumlah_perubahan',
    ];

    public function barang(): BelongsTo
    {
        return $this->belongsTo(Barang::class, 'barang_id');
    }
}
