<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tbl_mutasi_barang', function (Blueprint $table) {
            $table->id();
            $table->string('no_mutasi', 30)->unique();
            $table->unsignedBigInteger('pengaju_id');
            $table->unsignedBigInteger('lokasi_asal_id');
            $table->unsignedBigInteger('lokasi_tujuan_id');
            $table->text('keterangan')->nullable();
            $table->boolean('butuh_approval_kepsek')->default(false);
            $table->enum('status', ['Draft', 'Pending', 'Approved', 'Rejected'])->default('Draft');
            $table->timestamps();

            $table->foreign('pengaju_id')->references('id')->on('tbl_users');
            $table->foreign('lokasi_asal_id')->references('id')->on('tbl_lokasi');
            $table->foreign('lokasi_tujuan_id')->references('id')->on('tbl_lokasi');

            $table->index('status');
            $table->index('created_at');
        });

        DB::statement("ALTER TABLE tbl_mutasi_barang
            ADD CONSTRAINT tbl_mutasi_lokasi_check CHECK (lokasi_asal_id <> lokasi_tujuan_id)");
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_mutasi_barang');
    }
};
