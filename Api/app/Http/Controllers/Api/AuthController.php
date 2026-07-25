<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Resources\UserResource;
use App\Models\LogAktivitas;
use Dedoc\Scramble\Attributes\Group;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

#[Group('Autentikasi')]
class AuthController extends Controller
{
    /**
     * Login pengguna.
     *
     * Menerima username dan password, mengembalikan cookie session (Sanctum SPA)
     * serta data user yang login.
     *
     * @unauthenticated
     */
    public function login(LoginRequest $request): JsonResponse
    {
        $request->validated();

        $user = \App\Models\User::where('username', $request->username)->first();

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

        Auth::login($user);

        $request->session()->regenerate();

        LogAktivitas::create([
            'user_id' => $user->id,
            'aktivitas' => 'Login',
            'alamat_ip' => $request->ip(),
        ]);

        return response()->json([
            'message' => 'Login berhasil.',
            'data' => new UserResource($user->load('role', 'lokasi')),
        ]);
    }

    /**
     * Logout pengguna.
     *
     * Menghapus session dan menginvalidasi token, mencatat log aktivitas.
     */
    public function logout(Request $request): JsonResponse
    {
        $user = $request->user();

        Auth::guard('web')->logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        if ($user) {
            LogAktivitas::create([
                'user_id' => $user->id,
                'aktivitas' => 'Logout',
                'alamat_ip' => $request->ip(),
            ]);
        }

        return response()->json([
            'message' => 'Logout berhasil.',
        ]);
    }

    /**
     * Data pengguna saat ini.
     *
     * Mengembalikan data user yang sedang login beserta relasi role dan lokasi.
     */
    public function me(Request $request): JsonResponse
    {
        $user = $request->user()->load('role', 'lokasi');

        return response()->json([
            'data' => new UserResource($user),
        ]);
    }
}
