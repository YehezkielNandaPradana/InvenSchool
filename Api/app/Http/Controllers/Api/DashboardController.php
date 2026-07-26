<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index()
    {
        return response()->json([
            'total_barang' => 0,
            'total_barang_masuk' => 0,
            'total_barang_rusak' => 0,
            'total_kategori' => 0,
        ]);
    }
}
