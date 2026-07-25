<?php

namespace Database\Seeders;

use App\Models\KategoriDana;
use Illuminate\Database\Seeder;

class KategoriDanaSeeder extends Seeder
{
    public function run(): void
    {
        KategoriDana::insert([
            ['kode_dana' => 'BOS', 'nama_dana' => 'Bantuan Operasional Sekolah'],
            ['kode_dana' => 'KMT', 'nama_dana' => 'Komite'],
        ]);
    }
}
