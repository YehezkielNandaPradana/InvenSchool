<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tbl_lokasi', function (Blueprint $table) {
            $table->id();
            $table->string('kode_lokasi', 10)->unique();
            $table->string('nama_lokasi', 100);
            $table->enum('jenis_lokasi', ['Prodi', 'Unit Kerja', 'Gudang']);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_lokasi');
    }
};
