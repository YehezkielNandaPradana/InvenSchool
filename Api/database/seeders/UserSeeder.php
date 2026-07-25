<?php

namespace Database\Seeders;

use App\Models\Lokasi;
use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        $kepsek = Role::where('kode_role', 'KEPSEK')->value('id');
        $sarpras = Role::where('kode_role', 'SARPRAS')->value('id');
        $katu = Role::where('kode_role', 'KATU')->value('id');
        $kaprodi = Role::where('kode_role', 'KAPRODI')->value('id');
        $rpl = Lokasi::where('kode_lokasi', 'RPL')->value('id');

        $users = [
            [
                'username' => 'kepsek',
                'name' => 'Kepala Sekolah',
                'email' => 'kepsek@sekolah.test',
                'password' => bcrypt('password'),
                'role_id' => $kepsek,
                'status_aktif' => 'Aktif',
            ],
            [
                'username' => 'sarpras',
                'name' => 'Sarpras',
                'email' => 'sarpras@sekolah.test',
                'password' => bcrypt('password'),
                'role_id' => $sarpras,
                'status_aktif' => 'Aktif',
            ],
            [
                'username' => 'katu',
                'name' => 'Kepala Tata Usaha',
                'email' => 'katu@sekolah.test',
                'password' => bcrypt('password'),
                'role_id' => $katu,
                'status_aktif' => 'Aktif',
            ],
            [
                'username' => 'kaprodi_rpl',
                'name' => 'Ka. Prodi RPL',
                'email' => 'rpl@sekolah.test',
                'password' => bcrypt('password'),
                'role_id' => $kaprodi,
                'lokasi_id' => $rpl,
                'status_aktif' => 'Aktif',
            ],
        ];

        foreach ($users as $user) {
            User::create($user);
        }
    }
}
