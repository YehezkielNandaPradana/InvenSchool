<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class LampiranKerusakan extends Model
{
    protected $table = 'tbl_lampiran_kerusakan';

    protected $fillable = [
        'laporan_id',
        'jenis_foto',
        'file_path',
    ];

    public function laporan(): BelongsTo
    {
        return $this->belongsTo(LaporanKerusakan::class, 'laporan_id');
    }
}
