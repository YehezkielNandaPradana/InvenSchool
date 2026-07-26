<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class KondisiRusakController extends Controller
{
    public function index()
    {
        return response()->json([]);
    }

    public function store(Request $request)
    {
        return response()->json(['message' => 'created'], 201);
    }

    public function update(Request $request, $id)
    {
        return response()->json(['message' => 'updated']);
    }
}
