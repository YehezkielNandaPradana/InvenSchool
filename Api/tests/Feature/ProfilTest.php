<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ProfilTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_get_profil(): void
    {
        $response = $this->getJson('/api/profil');

        $response->assertStatus(200);
    }
}
