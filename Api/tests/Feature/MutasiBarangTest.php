<?php

namespace Tests\Feature;

use App\Models\MutasiBarang;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class MutasiBarangTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(\Database\Seeders\RoleSeeder::class);
        $this->seed(\Database\Seeders\LokasiSeeder::class);
        $this->seed(\Database\Seeders\KategoriDanaSeeder::class);
        $this->seed(\Database\Seeders\KategoriBarangSeeder::class);
        $this->seed(\Database\Seeders\UserSeeder::class);
    }

    private function katu(): User
    {
        return User::where('username', 'katu')->first();
    }

    private function sarpras(): User
    {
        return User::where('username', 'sarpras')->first();
    }

    private function kepsek(): User
    {
        return User::where('username', 'kepsek')->first();
    }

    private function kaprodi(): User
    {
        return User::where('username', 'kaprodi_rpl')->first();
    }

    private function createBarang(int $stok = 10): array
    {
        $lokasi = \App\Models\Lokasi::first();

        $response = $this->actingAs($this->katu())->postJson('/api/barang', [
            'nama_barang' => 'Komputer',
            'spesifikasi' => 'Intel i5',
            'kategori_dana_id' => \App\Models\KategoriDana::first()->id,
            'kategori_barang_id' => \App\Models\KategoriBarang::first()->id,
            'lokasi_id' => $lokasi->id,
            'kondisi_umum' => 'Baik',
        ]);

        $barang = $response->json('data');

        \Illuminate\Support\Facades\DB::table('tbl_barang')
            ->where('id', $barang['id'])
            ->update(['stok_baik' => $stok]);

        return \App\Models\Barang::find($barang['id'])->toArray();
    }

    private function createMutasiDraft(User $as, int $asalId, int $tujuanId, bool $butuhKepsek = false): array
    {
        $response = $this->actingAs($as)->postJson('/api/mutasi', [
            'lokasi_asal_id' => $asalId,
            'lokasi_tujuan_id' => $tujuanId,
            'keterangan' => 'Mutasi test',
            'butuh_approval_kepsek' => $butuhKepsek,
        ]);

        return $response->json('data');
    }

    public function test_unauthenticated_cannot_access(): void
    {
        $this->getJson('/api/mutasi')->assertStatus(401);
        $this->postJson('/api/mutasi', [])->assertStatus(401);
    }

    public function test_kaprodi_can_create_mutasi(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $asal = $lokasi[0]->id;
        $tujuan = $lokasi[1]->id;

        $response = $this->actingAs($this->kaprodi())->postJson('/api/mutasi', [
            'lokasi_asal_id' => $asal,
            'lokasi_tujuan_id' => $tujuan,
            'keterangan' => 'Pindah barang RPL ke TKJ',
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.status', 'Draft')
            ->assertJsonStructure(['data' => ['id', 'no_mutasi', 'status', 'pengaju', 'lokasi_asal', 'lokasi_tujuan']]);
    }

    public function test_kepsek_cannot_create_mutasi(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $response = $this->actingAs($this->kepsek())->postJson('/api/mutasi', [
            'lokasi_asal_id' => $lokasi[0]->id,
            'lokasi_tujuan_id' => $lokasi[1]->id,
        ]);

        $response->assertStatus(403);
    }

    public function test_sarpras_cannot_create_mutasi(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $response = $this->actingAs($this->sarpras())->postJson('/api/mutasi', [
            'lokasi_asal_id' => $lokasi[0]->id,
            'lokasi_tujuan_id' => $lokasi[1]->id,
        ]);

        $response->assertStatus(403);
    }

    public function test_asal_tujuan_must_differ(): void
    {
        $lokasi = \App\Models\Lokasi::first()->id;

        $response = $this->actingAs($this->kaprodi())->postJson('/api/mutasi', [
            'lokasi_asal_id' => $lokasi,
            'lokasi_tujuan_id' => $lokasi,
        ]);

        $response->assertStatus(422);
    }

    public function test_kaprodi_can_add_detail(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $response = $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 2,
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.jumlah', 2);
    }

    public function test_kaprodi_can_remove_detail(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $detail = $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 2,
        ])->json('data');

        $response = $this->actingAs($this->kaprodi())->deleteJson("/api/mutasi/{$mutasi['id']}/detail/{$detail['id']}");

        $response->assertStatus(200);
    }

    public function test_kaprodi_can_ajukan_with_details(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);

        $response = $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        $response->assertStatus(200)
            ->assertJsonPath('data.status', 'Pending');
    }

    public function test_cannot_ajukan_without_details(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $response = $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        $response->assertStatus(422);
    }

    public function test_cannot_ajukan_other_kaprodi_mutasi(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);

        $otherKaprodi = User::create([
            'username' => 'kaprodi_tkj',
            'name' => 'Ka. Prodi TKJ',
            'email' => 'tkj@sekolah.test',
            'password' => bcrypt('password'),
            'role_id' => \App\Models\Role::where('kode_role', 'KAPRODI')->first()->id,
            'lokasi_id' => \App\Models\Lokasi::where('kode_lokasi', 'TKJ')->first()->id,
            'status_aktif' => 'Aktif',
        ]);

        $response = $this->actingAs($otherKaprodi)->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        $response->assertStatus(403);
    }

    public function test_sarpras_can_verifikasi_approved(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);
        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        $response = $this->actingAs($this->sarpras())->postJson("/api/mutasi/{$mutasi['id']}/verifikasi-sarpras", [
            'status' => 'Approved',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('data.status', 'Approved');
    }

    public function test_sarpras_can_reject(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);
        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        $response = $this->actingAs($this->sarpras())->postJson("/api/mutasi/{$mutasi['id']}/verifikasi-sarpras", [
            'status' => 'Rejected',
            'catatan' => 'Barang tidak tersedia',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('data.status', 'Rejected');
    }

    public function test_kepsek_cannot_verifikasi_sarpras(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);
        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        $response = $this->actingAs($this->kepsek())->postJson("/api/mutasi/{$mutasi['id']}/verifikasi-sarpras", [
            'status' => 'Approved',
        ]);

        $response->assertStatus(403);
    }

    public function test_full_flow_with_kepsek_approval(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id, true);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);
        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        $sarprasResponse = $this->actingAs($this->sarpras())->postJson("/api/mutasi/{$mutasi['id']}/verifikasi-sarpras", [
            'status' => 'Approved',
        ]);

        $sarprasResponse->assertStatus(200)
            ->assertJsonPath('data.status', 'Pending');

        $kepsekResponse = $this->actingAs($this->kepsek())->postJson("/api/mutasi/{$mutasi['id']}/approval-kepsek", [
            'status' => 'Approved',
        ]);

        $kepsekResponse->assertStatus(200)
            ->assertJsonPath('data.status', 'Approved');
    }

    public function test_kepsek_cannot_approve_before_sarpras(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id, true);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);
        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        $response = $this->actingAs($this->kepsek())->postJson("/api/mutasi/{$mutasi['id']}/approval-kepsek", [
            'status' => 'Approved',
        ]);

        $response->assertStatus(422);
    }

    public function test_kepsek_can_reject(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id, true);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);
        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");
        $this->actingAs($this->sarpras())->postJson("/api/mutasi/{$mutasi['id']}/verifikasi-sarpras", [
            'status' => 'Approved',
        ]);

        $response = $this->actingAs($this->kepsek())->postJson("/api/mutasi/{$mutasi['id']}/approval-kepsek", [
            'status' => 'Rejected',
            'catatan' => 'Anggaran tidak mencukupi',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('data.status', 'Rejected');
    }

    public function test_all_roles_can_read(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);
        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        foreach (['kepsek', 'sarpras', 'katu', 'kaprodi_rpl'] as $username) {
            $user = User::where('username', $username)->first();
            $response = $this->actingAs($user)->getJson('/api/mutasi');
            $response->assertStatus(200)
                ->assertJsonStructure(['data', 'meta', 'links']);
        }
    }

    public function test_can_filter_by_status(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);
        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        $response = $this->actingAs($this->katu())->getJson('/api/mutasi?status=Pending');

        $response->assertStatus(200);
        $this->assertNotEmpty($response->json('data'));
        foreach ($response->json('data') as $item) {
            $this->assertEquals('Pending', $item['status']);
        }
    }

    public function test_show_returns_full_detail(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 2,
        ]);

        $response = $this->actingAs($this->katu())->getJson("/api/mutasi/{$mutasi['id']}");

        $response->assertStatus(200)
            ->assertJsonPath('data.id', $mutasi['id'])
            ->assertJsonStructure([
                'data' => [
                    'id', 'no_mutasi', 'status', 'pengaju', 'lokasi_asal', 'lokasi_tujuan',
                    'details', 'created_at',
                ],
            ]);
    }

    public function test_sarpras_approval_sets_catatan(): void
    {
        $lokasi = \App\Models\Lokasi::all();
        $barang = $this->createBarang();
        $mutasi = $this->createMutasiDraft($this->kaprodi(), $lokasi[0]->id, $lokasi[1]->id);

        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/detail", [
            'barang_id' => $barang['id'],
            'jumlah' => 1,
        ]);
        $this->actingAs($this->kaprodi())->postJson("/api/mutasi/{$mutasi['id']}/ajukan");

        $response = $this->actingAs($this->sarpras())->postJson("/api/mutasi/{$mutasi['id']}/verifikasi-sarpras", [
            'status' => 'Approved',
            'catatan' => 'Barang tersedia, lanjutkan',
        ]);

        $response->assertStatus(200);
        $approvals = $response->json('data.approvals');
        $this->assertNotEmpty($approvals);
        $this->assertEquals('Approved', $approvals[0]['status']);
        $this->assertEquals('Barang tersedia, lanjutkan', $approvals[0]['catatan']);
    }
}
