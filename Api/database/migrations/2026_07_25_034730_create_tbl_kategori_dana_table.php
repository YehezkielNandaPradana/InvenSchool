<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tbl_kategori_dana', function (Blueprint $table) {
            $table->id();
            $table->string('kode_dana', 10)->unique();
            $table->string('nama_dana', 100);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_kategori_dana');
    }
};
