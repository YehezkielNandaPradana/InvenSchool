<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ProfilController extends Controller
{
    public function show()
    {
        return response()->json([]);
    }

    public function update(Request $request)
    {
        return response()->json(['message' => 'updated']);
    }

    public function updatePassword(Request $request)
    {
        return response()->json(['message' => 'password updated']);
    }
}
