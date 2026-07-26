<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('tbl_users')->insert([
            'username' => 'admin',
            'name' => 'Admin',
            'email' => 'admin@invenschool.com',
            'password' => Hash::make('password'),
            'role_id' => 1,
            'status_aktif' => 'Aktif',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
}
