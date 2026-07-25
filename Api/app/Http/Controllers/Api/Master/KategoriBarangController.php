<?php

namespace App\Http\Controllers\Api\Master;

use App\Http\Controllers\Controller;
use App\Http\Requests\Master\StoreKategoriBarangRequest;
use App\Http\Requests\Master\UpdateKategoriBarangRequest;
use App\Http\Resources\KategoriBarangResource;
use App\Models\KategoriBarang;
use Dedoc\Scramble\Attributes\Group;
use Illuminate\Http\JsonResponse;

#[Group('Master — Kategori Barang')]
class KategoriBarangController extends Controller
{
    /**
     * Daftar kategori barang.
     *
     * Mengembalikan semua jenis kategori barang (Elektronik, Mebeulair, ATK, dll).
     */
    public function index(): JsonResponse
    {
        $this->authorize('viewAny', KategoriBarang::class);

        return response()->json([
            'data' => KategoriBarangResource::collection(KategoriBarang::all()),
        ]);
    }

    /**
     * Tambah kategori barang baru.
     */
    public function store(StoreKategoriBarangRequest $request): JsonResponse
    {
        $this->authorize('create', KategoriBarang::class);

        $kategoriBarang = KategoriBarang::create($request->validated());

        return response()->json([
            'data' => new KategoriBarangResource($kategoriBarang),
        ], 201);
    }

    /**
     * Detail kategori barang.
     */
    public function show(KategoriBarang $kategoriBarang): JsonResponse
    {
        $this->authorize('view', $kategoriBarang);

        return response()->json([
            'data' => new KategoriBarangResource($kategoriBarang),
        ]);
    }

    /**
     * Ubah kategori barang.
     */
    public function update(UpdateKategoriBarangRequest $request, KategoriBarang $kategoriBarang): JsonResponse
    {
        $this->authorize('update', $kategoriBarang);

        $kategoriBarang->update($request->validated());

        return response()->json([
            'data' => new KategoriBarangResource($kategoriBarang),
        ]);
    }

    /**
     * Hapus kategori barang.
     */
    public function destroy(KategoriBarang $kategoriBarang): JsonResponse
    {
        $this->authorize('delete', $kategoriBarang);

        $kategoriBarang->delete();

        return response()->json([
            'message' => 'Kategori barang berhasil dihapus.',
        ]);
    }
}
