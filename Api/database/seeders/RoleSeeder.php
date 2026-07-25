<?php

namespace Database\Seeders;

use App\Models\Role;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
    public function run(): void
    {
        Role::insert([
            ['kode_role' => 'KEPSEK', 'nama_role' => 'Kepala Sekolah'],
            ['kode_role' => 'SARPRAS', 'nama_role' => 'Sarpras'],
            ['kode_role' => 'KATU', 'nama_role' => 'Kepala Tata Usaha'],
            ['kode_role' => 'KAPRODI', 'nama_role' => 'Kepala Program Studi'],
        ]);
    }
}
