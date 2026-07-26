<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class BarangSeeder extends Seeder
{
    public function run(): void
    {
        $barang = [
            ['kode_barang' => 'BRG-001', 'nama_barang' => 'Meja Siswa', 'kategori' => 'Furnitur', 'jumlah' => 50, 'kondisi' => 'baik', 'lokasi' => 'Ruang Kelas A'],
            ['kode_barang' => 'BRG-002', 'nama_barang' => 'Kursi Siswa', 'kategori' => 'Furnitur', 'jumlah' => 100, 'kondisi' => 'baik', 'lokasi' => 'Ruang Kelas A'],
            ['kode_barang' => 'BRG-003', 'nama_barang' => 'Papan Tulis', 'kategori' => 'Alat Peraga', 'jumlah' => 10, 'kondisi' => 'baik', 'lokasi' => 'Ruang Kelas A'],
            ['kode_barang' => 'BRG-004', 'nama_barang' => 'Proyektor', 'kategori' => 'Elektronik', 'jumlah' => 5, 'kondisi' => 'baik', 'lokasi' => 'Ruang Multimedia'],
            ['kode_barang' => 'BRG-005', 'nama_barang' => 'Komputer', 'kategori' => 'Elektronik', 'jumlah' => 20, 'kondisi' => 'baik', 'lokasi' => 'Lab Komputer'],
        ];

        foreach ($barang as $item) {
            DB::table('barang')->insert($item);
        }
    }
}
