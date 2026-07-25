<?php

namespace Database\Seeders;

use App\Models\KategoriBarang;
use Illuminate\Database\Seeder;

class KategoriBarangSeeder extends Seeder
{
    public function run(): void
    {
        KategoriBarang::insert([
            ['kode_kategori' => 'ELEK', 'nama_kategori' => 'Elektronik'],
            ['kode_kategori' => 'MEBE', 'nama_kategori' => 'Mebeulair'],
            ['kode_kategori' => 'ATK', 'nama_kategori' => 'Alat Tulis Kantor'],
        ]);
    }
}
