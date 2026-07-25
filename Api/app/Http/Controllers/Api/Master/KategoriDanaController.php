<?php

namespace App\Http\Controllers\Api\Master;

use App\Http\Controllers\Controller;
use App\Http\Requests\Master\StoreKategoriDanaRequest;
use App\Http\Requests\Master\UpdateKategoriDanaRequest;
use App\Http\Resources\KategoriDanaResource;
use App\Models\KategoriDana;
use Dedoc\Scramble\Attributes\Group;
use Illuminate\Http\JsonResponse;

#[Group('Master — Kategori Dana')]
class KategoriDanaController extends Controller
{
    /**
     * Daftar kategori dana.
     *
     * Mengembalikan semua sumber dana (BOS, KMT, dll).
     */
    public function index(): JsonResponse
    {
        $this->authorize('viewAny', KategoriDana::class);

        return response()->json([
            'data' => KategoriDanaResource::collection(KategoriDana::all()),
        ]);
    }

    /**
     * Tambah kategori dana baru.
     */
    public function store(StoreKategoriDanaRequest $request): JsonResponse
    {
        $this->authorize('create', KategoriDana::class);

        $kategoriDana = KategoriDana::create($request->validated());

        return response()->json([
            'data' => new KategoriDanaResource($kategoriDana),
        ], 201);
    }

    /**
     * Detail kategori dana.
     */
    public function show(KategoriDana $kategoriDana): JsonResponse
    {
        $this->authorize('view', $kategoriDana);

        return response()->json([
            'data' => new KategoriDanaResource($kategoriDana),
        ]);
    }

    /**
     * Ubah kategori dana.
     */
    public function update(UpdateKategoriDanaRequest $request, KategoriDana $kategoriDana): JsonResponse
    {
        $this->authorize('update', $kategoriDana);

        $kategoriDana->update($request->validated());

        return response()->json([
            'data' => new KategoriDanaResource($kategoriDana),
        ]);
    }

    /**
     * Hapus kategori dana.
     */
    public function destroy(KategoriDana $kategoriDana): JsonResponse
    {
        $this->authorize('delete', $kategoriDana);

        $kategoriDana->delete();

        return response()->json([
            'message' => 'Kategori dana berhasil dihapus.',
        ]);
    }
}
