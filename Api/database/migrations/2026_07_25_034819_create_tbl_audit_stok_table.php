<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tbl_audit_stok', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('barang_id');
            $table->enum('jenis_transaksi', [
                'Barang Baru',
                'Mutasi Masuk',
                'Mutasi Keluar',
                'Kerusakan',
                'Perbaikan',
                'Penyesuaian Manual',
            ]);
            $table->string('referensi_tabel', 50)->nullable();
            $table->unsignedBigInteger('referensi_id')->nullable();
            $table->integer('stok_sebelum');
            $table->integer('stok_sesudah');
            $table->integer('jumlah_perubahan');
            $table->timestamp('created_at')->nullable();

            $table->foreign('barang_id')->references('id')->on('tbl_barang');
            $table->index('barang_id');
            $table->index('created_at');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_audit_stok');
    }
};
