<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class DashboardTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_get_dashboard_data(): void
    {
        $response = $this->getJson('/api/dashboard');

        $response->assertStatus(200);
    }
}
