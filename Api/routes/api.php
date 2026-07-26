<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BarangMasukController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\DataRekapController;
use App\Http\Controllers\Api\KondisiRusakController;
use App\Http\Controllers\Api\ProfilController;
use Illuminate\Support\Facades\Route;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    Route::get('/dashboard', [DashboardController::class, 'index']);

    Route::get('/barang-masuk', [BarangMasukController::class, 'index']);
    Route::post('/barang-masuk', [BarangMasukController::class, 'store']);
    Route::get('/barang-masuk/{id}', [BarangMasukController::class, 'show']);
    Route::put('/barang-masuk/{id}', [BarangMasukController::class, 'update']);
    Route::delete('/barang-masuk/{id}', [BarangMasukController::class, 'destroy']);

    Route::get('/data-rekap', [DataRekapController::class, 'index']);
    Route::get('/data-rekap/filter', [DataRekapController::class, 'filter']);
    Route::get('/data-rekap/export', [DataRekapController::class, 'export']);

    Route::get('/kondisi-rusak', [KondisiRusakController::class, 'index']);
    Route::post('/kondisi-rusak', [KondisiRusakController::class, 'store']);
    Route::put('/kondisi-rusak/{id}', [KondisiRusakController::class, 'update']);

    Route::get('/profil', [ProfilController::class, 'show']);
    Route::put('/profil', [ProfilController::class, 'update']);
    Route::put('/profil/password', [ProfilController::class, 'updatePassword']);
});
