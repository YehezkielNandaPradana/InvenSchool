<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tbl_laporan_kerusakan', function (Blueprint $table) {
            $table->id();
            $table->string('no_laporan', 30)->unique();
            $table->unsignedBigInteger('barang_id');
            $table->unsignedBigInteger('lokasi_id');
            $table->unsignedBigInteger('pelapor_id');
            $table->integer('jumlah_rusak');
            $table->text('deskripsi')->nullable();
            $table->enum('status', ['Draft', 'Pending', 'Approved', 'Rejected'])->default('Draft');
            $table->unsignedBigInteger('verifikator_id')->nullable();
            $table->timestamp('tanggal_verifikasi')->nullable();
            $table->text('catatan_verifikasi')->nullable();
            $table->timestamps();

            $table->foreign('barang_id')->references('id')->on('tbl_barang');
            $table->foreign('lokasi_id')->references('id')->on('tbl_lokasi');
            $table->foreign('pelapor_id')->references('id')->on('tbl_users');
            $table->foreign('verifikator_id')->references('id')->on('tbl_users');

            $table->index('status');
            $table->index('barang_id');
        });

        DB::statement("ALTER TABLE tbl_laporan_kerusakan
            ADD CONSTRAINT tbl_laporan_jumlah_rusak_check CHECK (jumlah_rusak > 0)");
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_laporan_kerusakan');
    }
};
