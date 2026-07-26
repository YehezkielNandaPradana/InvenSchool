<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class BarangMasukTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_get_barang_masuk(): void
    {
        $response = $this->getJson('/api/barang-masuk');

        $response->assertStatus(200);
    }
}
