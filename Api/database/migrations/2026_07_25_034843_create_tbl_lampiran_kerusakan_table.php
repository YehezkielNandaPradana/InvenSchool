<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tbl_lampiran_kerusakan', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('laporan_id');
            $table->enum('jenis_foto', ['Tampak Depan', 'Tampak Samping', 'Detail Kerusakan']);
            $table->string('file_path', 255);
            $table->timestamps();

            $table->foreign('laporan_id')->references('id')->on('tbl_laporan_kerusakan')->cascadeOnDelete();
            $table->index('laporan_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_lampiran_kerusakan');
    }
};
