<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    /** @param  string  ...$roles  */
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        $user = $request->user();

        if (!$user || !$user->role) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        if (!in_array($user->role->kode_role, $roles)) {
            return response()->json(['message' => 'Akses ditolak. Role Anda tidak memiliki izin.'], 403);
        }

        return $next($request);
    }
}
