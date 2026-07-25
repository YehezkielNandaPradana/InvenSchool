<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tbl_mutasi_approval', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('mutasi_id');
            $table->integer('urutan_approval');
            $table->unsignedBigInteger('approver_role_id');
            $table->unsignedBigInteger('approver_id')->nullable();
            $table->enum('status', ['Menunggu', 'Approved', 'Rejected'])->default('Menunggu');
            $table->text('catatan')->nullable();
            $table->timestamp('tanggal_approval')->nullable();
            $table->timestamps();

            $table->foreign('mutasi_id')->references('id')->on('tbl_mutasi_barang')->cascadeOnDelete();
            $table->foreign('approver_role_id')->references('id')->on('tbl_roles');
            $table->foreign('approver_id')->references('id')->on('tbl_users');
            $table->unique(['mutasi_id', 'urutan_approval']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_mutasi_approval');
    }
};
