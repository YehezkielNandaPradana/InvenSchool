<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    public function run(): void
    {
        $this->call([
            RoleSeeder::class,
            LokasiSeeder::class,
            KategoriDanaSeeder::class,
            KategoriBarangSeeder::class,
            UserSeeder::class,
        ]);
    }
}
