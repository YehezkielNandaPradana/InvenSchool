<?php

namespace Database\Seeders;

use App\Models\Lokasi;
use Illuminate\Database\Seeder;

class LokasiSeeder extends Seeder
{
    public function run(): void
    {
        Lokasi::insert([
            ['kode_lokasi' => 'RPL', 'nama_lokasi' => 'Rekayasa Perangkat Lunak', 'jenis_lokasi' => 'Prodi'],
            ['kode_lokasi' => 'TKJ', 'nama_lokasi' => 'Teknik Komputer dan Jaringan', 'jenis_lokasi' => 'Prodi'],
            ['kode_lokasi' => 'MM', 'nama_lokasi' => 'Multimedia', 'jenis_lokasi' => 'Prodi'],
            ['kode_lokasi' => 'TU', 'nama_lokasi' => 'Tata Usaha', 'jenis_lokasi' => 'Unit Kerja'],
            ['kode_lokasi' => 'GDG', 'nama_lokasi' => 'Gudang Umum', 'jenis_lokasi' => 'Gudang'],
        ]);
    }
}
