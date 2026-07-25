<?php

namespace App\Services;

use App\Models\MutasiApproval;
use App\Models\MutasiBarang;
use App\Models\Role;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class MutasiBarangService
{
    public function ajukan(MutasiBarang $mutasi, User $user): void
    {
        throw_if($mutasi->status !== 'Draft', \InvalidArgumentException::class, 'Hanya mutasi dengan status Draft yang bisa diajukan.');
        throw_if($mutasi->details()->count() === 0, \InvalidArgumentException::class, 'Minimal satu item barang harus ditambahkan.');

        $mutasi->update(['status' => 'Pending']);

        $sarprasRole = Role::where('kode_role', 'SARPRAS')->first();

        MutasiApproval::create([
            'mutasi_id' => $mutasi->id,
            'urutan_approval' => 1,
            'approver_role_id' => $sarprasRole->id,
            'status' => 'Menunggu',
        ]);
    }

    public function verifikasiSarpras(MutasiBarang $mutasi, User $user, string $status, ?string $catatan): void
    {
        throw_if($mutasi->status !== 'Pending', \InvalidArgumentException::class, 'Hanya mutasi dengan status Pending yang bisa diverifikasi.');

        $approval1 = $mutasi->approvals()->where('urutan_approval', 1)->firstOrFail();
        throw_if($approval1->status !== 'Menunggu', \InvalidArgumentException::class, 'Approval Sarpras sudah diproses.');

        $approval1->update([
            'approver_id' => $user->id,
            'status' => $status,
            'catatan' => $catatan,
            'tanggal_approval' => now(),
        ]);

        if ($status === 'Rejected') {
            $mutasi->update(['status' => 'Rejected']);
            return;
        }

        if (!$mutasi->butuh_approval_kepsek) {
            DB::statement("SET @audit_ref_table = 'tbl_mutasi_barang'");
            DB::statement("SET @audit_ref_id = {$mutasi->id}");
            DB::statement("SET @audit_jenis = 'Mutasi Keluar'");
            $mutasi->update(['status' => 'Approved']);
        } else {
            $kepsekRole = Role::where('kode_role', 'KEPSEK')->first();

            MutasiApproval::create([
                'mutasi_id' => $mutasi->id,
                'urutan_approval' => 2,
                'approver_role_id' => $kepsekRole->id,
                'status' => 'Menunggu',
            ]);
        }
    }

    public function approvalKepsek(MutasiBarang $mutasi, User $user, string $status, ?string $catatan): void
    {
        throw_if($mutasi->status !== 'Pending', \InvalidArgumentException::class, 'Hanya mutasi dengan status Pending yang bisa diverifikasi.');
        throw_if(!$mutasi->butuh_approval_kepsek, \InvalidArgumentException::class, 'Mutasi ini tidak memerlukan approval Kepsek.');

        $approval1 = $mutasi->approvals()->where('urutan_approval', 1)->firstOrFail();
        throw_if($approval1->status !== 'Approved', \InvalidArgumentException::class, 'Sarpras harus menyetujui terlebih dahulu.');

        $approval2 = $mutasi->approvals()->where('urutan_approval', 2)->firstOrFail();
        throw_if($approval2->status !== 'Menunggu', \InvalidArgumentException::class, 'Approval Kepsek sudah diproses.');

        $approval2->update([
            'approver_id' => $user->id,
            'status' => $status,
            'catatan' => $catatan,
            'tanggal_approval' => now(),
        ]);

        if ($status === 'Rejected') {
            $mutasi->update(['status' => 'Rejected']);
            return;
        }

        DB::statement("SET @audit_ref_table = 'tbl_mutasi_barang'");
        DB::statement("SET @audit_ref_id = {$mutasi->id}");
        DB::statement("SET @audit_jenis = 'Mutasi Keluar'");
        $mutasi->update(['status' => 'Approved']);
    }
}
