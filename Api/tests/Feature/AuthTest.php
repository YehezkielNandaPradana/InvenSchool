<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_login(): void
    {
        $response = $this->postJson('/api/login', [
            'email' => 'admin@invenschool.com',
            'password' => 'password',
        ]);

        $response->assertStatus(200);
    }

    public function test_user_cannot_login_with_invalid_credentials(): void
    {
        $response = $this->postJson('/api/login', [
            'email' => 'invalid@email.com',
            'password' => 'wrongpassword',
        ]);

        $response->assertStatus(401);
    }
}
