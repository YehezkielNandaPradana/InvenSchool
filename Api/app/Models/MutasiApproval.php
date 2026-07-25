<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MutasiApproval extends Model
{
    protected $table = 'tbl_mutasi_approval';

    protected $fillable = [
        'mutasi_id',
        'urutan_approval',
        'approver_role_id',
        'approver_id',
        'status',
        'catatan',
        'tanggal_approval',
    ];

    public function mutasi(): BelongsTo
    {
        return $this->belongsTo(MutasiBarang::class, 'mutasi_id');
    }

    public function approverRole(): BelongsTo
    {
        return $this->belongsTo(Role::class, 'approver_role_id');
    }

    public function approver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'approver_id');
    }
}
