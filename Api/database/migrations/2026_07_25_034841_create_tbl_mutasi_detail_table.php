<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tbl_mutasi_detail', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('mutasi_id');
            $table->unsignedBigInteger('barang_id');
            $table->integer('jumlah');

            $table->foreign('mutasi_id')->references('id')->on('tbl_mutasi_barang')->cascadeOnDelete();
            $table->foreign('barang_id')->references('id')->on('tbl_barang');
            $table->index('barang_id');
        });

        DB::statement("ALTER TABLE tbl_mutasi_detail
            ADD CONSTRAINT tbl_mutasi_detail_jumlah_check CHECK (jumlah > 0)");
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_mutasi_detail');
    }
};
