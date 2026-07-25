<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BarangController;
use App\Http\Controllers\Api\Master\KategoriBarangController;
use App\Http\Controllers\Api\Master\KategoriDanaController;
use App\Http\Controllers\Api\Master\LokasiController;
use App\Http\Controllers\Api\MutasiBarangController;
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

    Route::get('/mutasi', [MutasiBarangController::class, 'index']);
    Route::post('/mutasi', [MutasiBarangController::class, 'store']);
    Route::get('/mutasi/{mutasi}', [MutasiBarangController::class, 'show']);
    Route::post('/mutasi/{mutasi}/detail', [MutasiBarangController::class, 'addDetail']);
    Route::delete('/mutasi/{mutasi}/detail/{detail}', [MutasiBarangController::class, 'removeDetail']);
    Route::post('/mutasi/{mutasi}/ajukan', [MutasiBarangController::class, 'ajukan']);
    Route::post('/mutasi/{mutasi}/verifikasi-sarpras', [MutasiBarangController::class, 'verifikasiSarpras']);
    Route::post('/mutasi/{mutasi}/approval-kepsek', [MutasiBarangController::class, 'approvalKepsek']);
});
