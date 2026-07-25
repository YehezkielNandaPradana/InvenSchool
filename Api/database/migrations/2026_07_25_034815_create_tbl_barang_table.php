<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tbl_barang', function (Blueprint $table) {
            $table->id();
            $table->string('kode_barang', 30)->unique();
            $table->unsignedBigInteger('kategori_dana_id');
            $table->unsignedBigInteger('kategori_barang_id');
            $table->unsignedBigInteger('lokasi_id');
            $table->unsignedBigInteger('barang_asal_id')->nullable();
            $table->string('nama_barang', 200);
            $table->text('spesifikasi')->nullable();
            $table->integer('stok_baik')->default(0);
            $table->integer('stok_rusak')->default(0);
            $table->enum('kondisi_umum', ['Baik', 'Rusak Ringan', 'Rusak Berat'])->default('Baik');
            $table->enum('status_aktif', ['Aktif', 'Non-Aktif', 'Dihapus'])->default('Aktif');
            $table->unsignedBigInteger('created_by');
            $table->timestamps();

            $table->foreign('kategori_dana_id')->references('id')->on('tbl_kategori_dana');
            $table->foreign('kategori_barang_id')->references('id')->on('tbl_kategori_barang');
            $table->foreign('lokasi_id')->references('id')->on('tbl_lokasi');
            $table->foreign('created_by')->references('id')->on('tbl_users');
        });

        DB::statement("ALTER TABLE tbl_barang
            ADD COLUMN stok_total INT GENERATED ALWAYS AS (stok_baik + stok_rusak) STORED
            AFTER stok_rusak");

        DB::statement("ALTER TABLE tbl_barang
            ADD CONSTRAINT tbl_barang_stok_baik_check CHECK (stok_baik >= 0)");

        DB::statement("ALTER TABLE tbl_barang
            ADD CONSTRAINT tbl_barang_stok_rusak_check CHECK (stok_rusak >= 0)");

        DB::statement("ALTER TABLE tbl_barang
            ADD CONSTRAINT tbl_barang_barang_asal_id_foreign
            FOREIGN KEY (barang_asal_id) REFERENCES tbl_barang(id)");
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_barang');
    }
};
