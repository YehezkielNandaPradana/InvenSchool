<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BarangController;
use App\Http\Controllers\Api\Master\KategoriBarangController;
use App\Http\Controllers\Api\Master\KategoriDanaController;
use App\Http\Controllers\Api\Master\LokasiController;
use Illuminate\Support\Facades\Route;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    Route::apiResource('/master/lokasi', LokasiController::class);
    Route::apiResource('/master/kategori-dana', KategoriDanaController::class);
    Route::apiResource('/master/kategori-barang', KategoriBarangController::class);

    Route::get('/barang/{barang}/riwayat-stok', [BarangController::class, 'riwayatStok']);
    Route::apiResource('/barang', BarangController::class);
});
