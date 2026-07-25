<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tbl_penomoran_kode', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('kategori_dana_id');
            $table->unsignedBigInteger('lokasi_id');
            $table->integer('nomor_terakhir')->default(0);

            $table->foreign('kategori_dana_id')->references('id')->on('tbl_kategori_dana');
            $table->foreign('lokasi_id')->references('id')->on('tbl_lokasi');
            $table->unique(['kategori_dana_id', 'lokasi_id']);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_penomoran_kode');
    }
};
