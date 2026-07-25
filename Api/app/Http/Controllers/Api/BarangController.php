<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreBarangRequest;
use App\Http\Requests\UpdateBarangRequest;
use App\Http\Resources\AuditStokResource;
use App\Http\Resources\BarangResource;
use App\Models\Barang;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BarangController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $this->authorize('viewAny', Barang::class);

        $barang = Barang::with(['kategoriDana', 'kategoriBarang', 'lokasi', 'createdBy'])
            ->lokasiUser($request->user())
            ->when($request->lokasi_id, fn ($q, $v) => $q->where('lokasi_id', $v))
            ->when($request->kategori_dana_id, fn ($q, $v) => $q->where('kategori_dana_id', $v))
            ->when($request->kategori_barang_id, fn ($q, $v) => $q->where('kategori_barang_id', $v))
            ->when($request->status_aktif, fn ($q, $v) => $q->where('status_aktif', $v))
            ->paginate(25);

        return BarangResource::collection($barang)->response();
    }

    public function store(StoreBarangRequest $request): JsonResponse
    {
        $this->authorize('create', Barang::class);

        $barang = Barang::create(
            $request->validated() + ['created_by' => $request->user()->id]
        );

        $barang->refresh();
        $barang->load(['kategoriDana', 'kategoriBarang', 'lokasi', 'createdBy']);

        return response()->json([
            'data' => new BarangResource($barang),
        ], 201);
    }

    public function show(Barang $barang): JsonResponse
    {
        $this->authorize('view', $barang);

        $barang->load(['kategoriDana', 'kategoriBarang', 'lokasi', 'createdBy']);

        return response()->json([
            'data' => new BarangResource($barang),
        ]);
    }

    public function update(UpdateBarangRequest $request, Barang $barang): JsonResponse
    {
        $this->authorize('update', $barang);

        $barang->update($request->validated());
        $barang->load(['kategoriDana', 'kategoriBarang', 'lokasi', 'createdBy']);

        return response()->json([
            'data' => new BarangResource($barang),
        ]);
    }

    public function destroy(Barang $barang): JsonResponse
    {
        $this->authorize('delete', $barang);

        $barang->update(['status_aktif' => 'Dihapus']);

        return response()->json([
            'message' => 'Barang berhasil dihapus.',
        ]);
    }

    public function riwayatStok(Barang $barang): JsonResponse
    {
        $this->authorize('view', $barang);

        $audit = $barang->auditStok()
            ->orderBy('created_at', 'desc')
            ->paginate(25);

        return AuditStokResource::collection($audit)->response();
    }
}
