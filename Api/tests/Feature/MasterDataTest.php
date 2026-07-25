<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class MasterDataTest extends TestCase
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

    public function test_unauthenticated_cannot_access_lokasi(): void
    {
        $this->getJson('/api/master/lokasi')->assertStatus(401);
    }

    public function test_unauthenticated_cannot_access_kategori_dana(): void
    {
        $this->getJson('/api/master/kategori-dana')->assertStatus(401);
    }

    public function test_unauthenticated_cannot_access_kategori_barang(): void
    {
        $this->getJson('/api/master/kategori-barang')->assertStatus(401);
    }

    public function test_katu_can_create_lokasi(): void
    {
        $user = User::where('username', 'katu')->first();

        $response = $this->actingAs($user)->postJson('/api/master/lokasi', [
            'kode_lokasi' => 'GDG-BARU',
            'nama_lokasi' => 'Gudang Baru',
            'jenis_lokasi' => 'Gudang',
        ]);

        $response->assertStatus(201)->assertJsonPath('data.kode_lokasi', 'GDG-BARU');
    }

    public function test_katu_can_create_kategori_dana(): void
    {
        $user = User::where('username', 'katu')->first();

        $response = $this->actingAs($user)->postJson('/api/master/kategori-dana', [
            'kode_dana' => 'DANA-X',
            'nama_dana' => 'Dana X',
        ]);

        $response->assertStatus(201)->assertJsonPath('data.kode_dana', 'DANA-X');
    }

    public function test_katu_can_create_kategori_barang(): void
    {
        $user = User::where('username', 'katu')->first();

        $response = $this->actingAs($user)->postJson('/api/master/kategori-barang', [
            'kode_kategori' => 'KTG-X',
            'nama_kategori' => 'Kategori X',
        ]);

        $response->assertStatus(201)->assertJsonPath('data.kode_kategori', 'KTG-X');
    }

    public function test_katu_can_read_lokasi(): void
    {
        $user = User::where('username', 'katu')->first();

        $response = $this->actingAs($user)->getJson('/api/master/lokasi');

        $response->assertStatus(200)->assertJsonCount(5, 'data');
    }

    public function test_katu_can_read_kategori_dana(): void
    {
        $user = User::where('username', 'katu')->first();

        $response = $this->actingAs($user)->getJson('/api/master/kategori-dana');

        $response->assertStatus(200)->assertJsonCount(2, 'data');
    }

    public function test_katu_can_read_kategori_barang(): void
    {
        $user = User::where('username', 'katu')->first();

        $response = $this->actingAs($user)->getJson('/api/master/kategori-barang');

        $response->assertStatus(200)->assertJsonCount(3, 'data');
    }

    public function test_katu_can_update_lokasi(): void
    {
        $user = User::where('username', 'katu')->first();
        $items = $this->actingAs($user)->getJson('/api/master/lokasi')->json('data');

        $response = $this->actingAs($user)->putJson('/api/master/lokasi/' . $items[0]['id'], [
            'kode_lokasi' => 'UPD',
            'nama_lokasi' => 'Updated',
            'jenis_lokasi' => 'Unit Kerja',
        ]);

        $response->assertStatus(200)->assertJsonPath('data.kode_lokasi', 'UPD');
    }

    public function test_katu_can_update_kategori_dana(): void
    {
        $user = User::where('username', 'katu')->first();
        $items = $this->actingAs($user)->getJson('/api/master/kategori-dana')->json('data');

        $response = $this->actingAs($user)->putJson('/api/master/kategori-dana/' . $items[0]['id'], [
            'kode_dana' => 'UPD',
            'nama_dana' => 'Updated',
        ]);

        $response->assertStatus(200)->assertJsonPath('data.kode_dana', 'UPD');
    }

    public function test_katu_can_update_kategori_barang(): void
    {
        $user = User::where('username', 'katu')->first();
        $items = $this->actingAs($user)->getJson('/api/master/kategori-barang')->json('data');

        $response = $this->actingAs($user)->putJson('/api/master/kategori-barang/' . $items[0]['id'], [
            'kode_kategori' => 'UPD',
            'nama_kategori' => 'Updated',
        ]);

        $response->assertStatus(200)->assertJsonPath('data.kode_kategori', 'UPD');
    }

    public function test_katu_can_delete_lokasi(): void
    {
        $user = User::where('username', 'katu')->first();
        $lokasi = \App\Models\Lokasi::where('kode_lokasi', 'GDG')->first();

        $response = $this->actingAs($user)->deleteJson('/api/master/lokasi/' . $lokasi->id);

        $response->assertStatus(200)->assertJsonStructure(['message']);
    }

    public function test_katu_can_delete_kategori_dana(): void
    {
        $user = User::where('username', 'katu')->first();
        $items = $this->actingAs($user)->getJson('/api/master/kategori-dana')->json('data');

        $response = $this->actingAs($user)->deleteJson('/api/master/kategori-dana/' . $items[0]['id']);

        $response->assertStatus(200)->assertJsonStructure(['message']);
    }

    public function test_katu_can_delete_kategori_barang(): void
    {
        $user = User::where('username', 'katu')->first();
        $items = $this->actingAs($user)->getJson('/api/master/kategori-barang')->json('data');

        $response = $this->actingAs($user)->deleteJson('/api/master/kategori-barang/' . $items[0]['id']);

        $response->assertStatus(200)->assertJsonStructure(['message']);
    }

    public function test_non_katu_cannot_create_lokasi(): void
    {
        foreach (['kepsek', 'sarpras', 'kaprodi_rpl'] as $username) {
            $user = User::where('username', $username)->first();
            $response = $this->actingAs($user)->postJson('/api/master/lokasi', [
                'kode_lokasi' => 'BARU',
                'nama_lokasi' => 'Baru',
                'jenis_lokasi' => 'Gudang',
            ]);
            $response->assertStatus(403);
        }
    }

    public function test_non_katu_cannot_update_lokasi(): void
    {
        $katu = User::where('username', 'katu')->first();
        $items = $this->actingAs($katu)->getJson('/api/master/lokasi')->json('data');

        foreach (['kepsek', 'sarpras', 'kaprodi_rpl'] as $username) {
            $user = User::where('username', $username)->first();
            $response = $this->actingAs($user)->putJson('/api/master/lokasi/' . $items[0]['id'], [
                'kode_lokasi' => $items[0]['kode_lokasi'],
                'nama_lokasi' => $items[0]['nama_lokasi'],
                'jenis_lokasi' => $items[0]['jenis_lokasi'],
            ]);
            $response->assertStatus(403);
        }
    }

    public function test_non_katu_cannot_delete_lokasi(): void
    {
        $katu = User::where('username', 'katu')->first();
        $items = $this->actingAs($katu)->getJson('/api/master/lokasi')->json('data');

        foreach (['kepsek', 'sarpras', 'kaprodi_rpl'] as $username) {
            $user = User::where('username', $username)->first();
            $response = $this->actingAs($user)->deleteJson('/api/master/lokasi/' . $items[0]['id']);
            $response->assertStatus(403);
        }
    }

    public function test_non_katu_can_read_lokasi(): void
    {
        foreach (['kepsek', 'sarpras', 'kaprodi_rpl'] as $username) {
            $user = User::where('username', $username)->first();
            $response = $this->actingAs($user)->getJson('/api/master/lokasi');
            $response->assertStatus(200)->assertJsonStructure(['data']);
        }
    }
}
