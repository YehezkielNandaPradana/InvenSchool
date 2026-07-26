<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class KondisiRusakTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_get_kondisi_rusak(): void
    {
        $response = $this->getJson('/api/kondisi-rusak');

        $response->assertStatus(200);
    }
}
