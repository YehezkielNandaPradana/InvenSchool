<?php

namespace App\Http\Controllers\Api\Master;

use App\Http\Controllers\Controller;
use App\Http\Requests\Master\StoreKategoriBarangRequest;
use App\Http\Requests\Master\UpdateKategoriBarangRequest;
use App\Http\Resources\KategoriBarangResource;
use App\Models\KategoriBarang;
use Illuminate\Http\JsonResponse;

class KategoriBarangController extends Controller
{
    public function index(): JsonResponse
    {
        $this->authorize('viewAny', KategoriBarang::class);

        return response()->json([
            'data' => KategoriBarangResource::collection(KategoriBarang::all()),
        ]);
    }

    public function store(StoreKategoriBarangRequest $request): JsonResponse
    {
        $this->authorize('create', KategoriBarang::class);

        $kategoriBarang = KategoriBarang::create($request->validated());

        return response()->json([
            'data' => new KategoriBarangResource($kategoriBarang),
        ], 201);
    }

    public function show(KategoriBarang $kategoriBarang): JsonResponse
    {
        $this->authorize('view', $kategoriBarang);

        return response()->json([
            'data' => new KategoriBarangResource($kategoriBarang),
        ]);
    }

    public function update(UpdateKategoriBarangRequest $request, KategoriBarang $kategoriBarang): JsonResponse
    {
        $this->authorize('update', $kategoriBarang);

        $kategoriBarang->update($request->validated());

        return response()->json([
            'data' => new KategoriBarangResource($kategoriBarang),
        ]);
    }

    public function destroy(KategoriBarang $kategoriBarang): JsonResponse
    {
        $this->authorize('delete', $kategoriBarang);

        $kategoriBarang->delete();

        return response()->json([
            'message' => 'Kategori barang berhasil dihapus.',
        ]);
    }
}
