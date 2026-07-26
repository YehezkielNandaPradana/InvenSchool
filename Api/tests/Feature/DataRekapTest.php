<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class DataRekapTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_get_data_rekap(): void
    {
        $response = $this->getJson('/api/data-rekap');

        $response->assertStatus(200);
    }
}
