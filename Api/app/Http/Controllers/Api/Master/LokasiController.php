<?php

namespace App\Http\Controllers\Api\Master;

use App\Http\Controllers\Controller;
use App\Http\Requests\Master\StoreLokasiRequest;
use App\Http\Requests\Master\UpdateLokasiRequest;
use App\Http\Resources\LokasiResource;
use App\Models\Lokasi;
use Dedoc\Scramble\Attributes\Group;
use Illuminate\Http\JsonResponse;

#[Group('Master — Lokasi')]
class LokasiController extends Controller
{
    /**
     * Daftar semua lokasi.
     *
     * Mengembalikan semua data lokasi (Prodi, Unit Kerja, Gudang).
     */
    public function index(): JsonResponse
    {
        $this->authorize('viewAny', Lokasi::class);

        return response()->json([
            'data' => LokasiResource::collection(Lokasi::all()),
        ]);
    }

    /**
     * Tambah lokasi baru.
     */
    public function store(StoreLokasiRequest $request): JsonResponse
    {
        $this->authorize('create', Lokasi::class);

        $lokasi = Lokasi::create($request->validated());

        return response()->json([
            'data' => new LokasiResource($lokasi),
        ], 201);
    }

    /**
     * Detail lokasi.
     */
    public function show(Lokasi $lokasi): JsonResponse
    {
        $this->authorize('view', $lokasi);

        return response()->json([
            'data' => new LokasiResource($lokasi),
        ]);
    }

    /**
     * Ubah data lokasi.
     */
    public function update(UpdateLokasiRequest $request, Lokasi $lokasi): JsonResponse
    {
        $this->authorize('update', $lokasi);

        $lokasi->update($request->validated());

        return response()->json([
            'data' => new LokasiResource($lokasi),
        ]);
    }

    /**
     * Hapus lokasi.
     */
    public function destroy(Lokasi $lokasi): JsonResponse
    {
        $this->authorize('delete', $lokasi);

        $lokasi->delete();

        return response()->json([
            'message' => 'Lokasi berhasil dihapus.',
        ]);
    }
}
