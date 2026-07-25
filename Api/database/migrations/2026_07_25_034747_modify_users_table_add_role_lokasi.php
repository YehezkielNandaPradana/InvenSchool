<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('nip_nik', 30)->nullable()->unique()->after('id');
            $table->string('username', 50)->unique()->after('nip_nik');
            $table->string('name', 100)->nullable()->change();
            $table->string('email', 100)->nullable()->change();
            $table->unsignedBigInteger('role_id')->nullable()->after('email');
            $table->unsignedBigInteger('lokasi_id')->nullable()->after('role_id');
            $table->enum('status_aktif', ['Aktif', 'Nonaktif'])->default('Aktif')->after('lokasi_id');

            $table->foreign('role_id')->references('id')->on('tbl_roles');
            $table->foreign('lokasi_id')->references('id')->on('tbl_lokasi');
        });

        Schema::rename('users', 'tbl_users');
    }

    public function down(): void
    {
        Schema::rename('tbl_users', 'users');

        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['lokasi_id']);
            $table->dropForeign(['role_id']);
            $table->dropColumn(['nip_nik', 'username', 'role_id', 'lokasi_id', 'status_aktif']);
            $table->string('name', 255)->change();
            $table->string('email', 255)->nullable(false)->change();
        });
    }
};
