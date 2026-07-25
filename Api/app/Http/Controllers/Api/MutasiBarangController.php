<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Mutasi\AddMutasiDetailRequest;
use App\Http\Requests\Mutasi\AjukanMutasiBarangRequest;
use App\Http\Requests\Mutasi\ApprovalKepsekRequest;
use App\Http\Requests\Mutasi\StoreMutasiBarangRequest;
use App\Http\Requests\Mutasi\VerifikasiSarprasRequest;
use App\Http\Resources\MutasiBarangResource;
use App\Http\Resources\MutasiDetailResource;
use App\Models\MutasiBarang;
use App\Models\MutasiDetail;
use App\Services\MutasiBarangService;
use Dedoc\Scramble\Attributes\Group;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use InvalidArgumentException;

#[Group('Mutasi Barang')]
class MutasiBarangController extends Controller
{
    public function __construct(
        protected MutasiBarangService $mutasiBarangService
    ) {}

    /**
     * Daftar mutasi barang.
     *
     * Mengembalikan daftar mutasi terpagina. Filter berdasarkan status dan pengaju_id.
     */
    public function index(Request $request): JsonResponse
    {
        $this->authorize('viewAny', MutasiBarang::class);

        $mutasi = MutasiBarang::with(['pengaju', 'lokasiAsal', 'lokasiTujuan', 'details.barang', 'approvals.approverRole'])
            ->when($request->status, fn ($q, $v) => $q->where('status', $v))
            ->when($request->pengaju_id, fn ($q, $v) => $q->where('pengaju_id', $v))
            ->orderBy('created_at', 'desc')
            ->paginate(25);

        return MutasiBarangResource::collection($mutasi)->response();
    }

    /**
     * Buat draft mutasi.
     *
     * Membuat header mutasi baru dengan status Draft.
     * no_mutasi digenerate otomatis dengan format MUT-{tahun}-{nomor urut}.
     */
    public function store(StoreMutasiBarangRequest $request): JsonResponse
    {
        $this->authorize('create', MutasiBarang::class);

        $tahun = now()->year;
        $last = MutasiBarang::whereYear('created_at', $tahun)->count();

        $mutasi = MutasiBarang::create($request->validated() + [
            'no_mutasi' => sprintf('MUT-%s-%04d', $tahun, $last + 1),
            'pengaju_id' => $request->user()->id,
            'status' => 'Draft',
        ]);

        $mutasi->load(['pengaju', 'lokasiAsal', 'lokasiTujuan']);

        return response()->json([
            'data' => new MutasiBarangResource($mutasi),
        ], 201);
    }

    /**
     * Detail mutasi.
     *
     * Menampilkan informasi lengkap mutasi termasuk detail barang dan riwayat approval.
     */
    public function show(MutasiBarang $mutasi): JsonResponse
    {
        $this->authorize('view', $mutasi);

        $mutasi->load(['pengaju', 'lokasiAsal', 'lokasiTujuan', 'details.barang', 'approvals.approverRole', 'approvals.approver']);

        return response()->json([
            'data' => new MutasiBarangResource($mutasi),
        ]);
    }

    /**
     * Tambah item barang ke draft mutasi.
     *
     * Menambahkan barang dan jumlah ke dalam mutasi yang masih berstatus Draft.
     */
    public function addDetail(AddMutasiDetailRequest $request, MutasiBarang $mutasi): JsonResponse
    {
        $this->authorize('addDetail', $mutasi);

        $detail = $mutasi->details()->create($request->validated());

        $detail->load('barang');

        return response()->json([
            'data' => new MutasiDetailResource($detail),
        ], 201);
    }

    /**
     * Hapus item dari draft mutasi.
     */
    public function removeDetail(MutasiBarang $mutasi, MutasiDetail $detail): JsonResponse
    {
        $this->authorize('removeDetail', $mutasi);

        if ($detail->mutasi_id !== $mutasi->id) {
            abort(404);
        }

        $detail->delete();

        return response()->json([
            'message' => 'Item barang berhasil dihapus dari mutasi.',
        ]);
    }

    /**
     * Ajukan mutasi ke Sarpras.
     *
     * Mengubah status dari Draft menjadi Pending dan membuat entri approval Sarpras.
     * Minimal satu item barang harus ditambahkan sebelum pengajuan.
     *
     * @response 422 {"message": "Minimal satu item barang harus ditambahkan."}
     * @throws \InvalidArgumentException
     */
    public function ajukan(AjukanMutasiBarangRequest $request, MutasiBarang $mutasi): JsonResponse
    {
        $this->authorize('ajukan', $mutasi);

        try {
            $this->mutasiBarangService->ajukan($mutasi, $request->user());
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        $mutasi->refresh();
        $mutasi->load(['pengaju', 'lokasiAsal', 'lokasiTujuan', 'details.barang', 'approvals.approverRole']);

        return response()->json([
            'data' => new MutasiBarangResource($mutasi),
        ]);
    }

    /**
     * Sarpras verifikasi mutasi.
     *
     * Sarpras menyetujui atau menolak mutasi yang sudah diajukan.
     * Jika butuh_approval_kepsek=true, status tetap Pending menunggu approval Kepsek.
     * Jika disetujui dan tidak perlu Kepsek, trigger database akan memindahkan stok.
     *
     * @response 422 {"message": "Hanya mutasi dengan status Pending yang bisa diverifikasi."}
     * @throws \InvalidArgumentException
     */
    public function verifikasiSarpras(VerifikasiSarprasRequest $request, MutasiBarang $mutasi): JsonResponse
    {
        $this->authorize('verifikasiSarpras', $mutasi);

        try {
            $this->mutasiBarangService->verifikasiSarpras(
                $mutasi,
                $request->user(),
                $request->input('status'),
                $request->input('catatan')
            );
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        $mutasi->refresh();
        $mutasi->load(['pengaju', 'lokasiAsal', 'lokasiTujuan', 'details.barang', 'approvals.approverRole']);

        return response()->json([
            'data' => new MutasiBarangResource($mutasi),
        ]);
    }

    /**
     * Kepsek approval final mutasi.
     *
     * Kepala Sekolah menyetujui atau menolak mutasi yang sudah diverifikasi Sarpras.
     * Hanya untuk mutasi dengan butuh_approval_kepsek=true.
     * Jika disetujui, trigger database memindahkan stok dan mencatat audit.
     *
     * @response 422 {"message": "Sarpras harus menyetujui terlebih dahulu."}
     * @throws \InvalidArgumentException
     */
    public function approvalKepsek(ApprovalKepsekRequest $request, MutasiBarang $mutasi): JsonResponse
    {
        $this->authorize('approvalKepsek', $mutasi);

        try {
            $this->mutasiBarangService->approvalKepsek(
                $mutasi,
                $request->user(),
                $request->input('status'),
                $request->input('catatan')
            );
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        $mutasi->refresh();
        $mutasi->load(['pengaju', 'lokasiAsal', 'lokasiTujuan', 'details.barang', 'approvals.approverRole']);

        return response()->json([
            'data' => new MutasiBarangResource($mutasi),
        ]);
    }
}
