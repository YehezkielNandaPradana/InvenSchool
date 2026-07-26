<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class DataRekapController extends Controller
{
    public function index()
    {
        return response()->json([]);
    }

    public function filter(Request $request)
    {
        return response()->json([]);
    }

    public function export(Request $request)
    {
        return response()->json([]);
    }
}
