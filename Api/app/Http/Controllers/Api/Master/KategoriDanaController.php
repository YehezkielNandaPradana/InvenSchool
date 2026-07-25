<?php

namespace App\Http\Controllers\Api\Master;

use App\Http\Controllers\Controller;
use App\Http\Requests\Master\StoreKategoriDanaRequest;
use App\Http\Requests\Master\UpdateKategoriDanaRequest;
use App\Http\Resources\KategoriDanaResource;
use App\Models\KategoriDana;
use Illuminate\Http\JsonResponse;

class KategoriDanaController extends Controller
{
    public function index(): JsonResponse
    {
        $this->authorize('viewAny', KategoriDana::class);

        return response()->json([
            'data' => KategoriDanaResource::collection(KategoriDana::all()),
        ]);
    }

    public function store(StoreKategoriDanaRequest $request): JsonResponse
    {
        $this->authorize('create', KategoriDana::class);

        $kategoriDana = KategoriDana::create($request->validated());

        return response()->json([
            'data' => new KategoriDanaResource($kategoriDana),
        ], 201);
    }

    public function show(KategoriDana $kategoriDana): JsonResponse
    {
        $this->authorize('view', $kategoriDana);

        return response()->json([
            'data' => new KategoriDanaResource($kategoriDana),
        ]);
    }

    public function update(UpdateKategoriDanaRequest $request, KategoriDana $kategoriDana): JsonResponse
    {
        $this->authorize('update', $kategoriDana);

        $kategoriDana->update($request->validated());

        return response()->json([
            'data' => new KategoriDanaResource($kategoriDana),
        ]);
    }

    public function destroy(KategoriDana $kategoriDana): JsonResponse
    {
        $this->authorize('delete', $kategoriDana);

        $kategoriDana->delete();

        return response()->json([
            'message' => 'Kategori dana berhasil dihapus.',
        ]);
    }
}
