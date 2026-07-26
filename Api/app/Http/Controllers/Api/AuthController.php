<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Resources\UserResource;
use App\Models\LogAktivitas;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(LoginRequest $request): JsonResponse
    {
        $request->validated();

        $field = $request->has('email') ? 'email' : 'username';
        $value = $request->input($field);

        $user = \App\Models\User::where($field, $value)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'Username atau password salah.',
            ], 401);
        }

        if ($user->status_aktif !== 'Aktif') {
            return response()->json([
                'message' => 'Akun Anda tidak aktif. Hubungi administrator.',
            ], 403);
        }

        $token = $user->createToken('auth-token')->plainTextToken;

        LogAktivitas::create([
            'user_id' => $user->id,
            'aktivitas' => 'Login',
            'alamat_ip' => $request->ip(),
        ]);

        return response()->json([
            'message' => 'Login berhasil.',
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role?->nama_role ?? $user->getRoleNames()->first(),
            ],
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $user = $request->user();

        $user->currentAccessToken()->delete();

        LogAktivitas::create([
            'user_id' => $user->id,
            'aktivitas' => 'Logout',
            'alamat_ip' => $request->ip(),
        ]);

        return response()->json([
            'message' => 'Logout berhasil.',
        ]);
    }

    public function me(Request $request): JsonResponse
    {
        $user = $request->user()->load('role', 'lokasi');

        return response()->json([
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role?->nama_role ?? $user->getRoleNames()->first(),
            ],
        ]);
    }
}
