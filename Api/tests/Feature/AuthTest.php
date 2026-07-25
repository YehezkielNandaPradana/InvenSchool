<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(\Database\Seeders\RoleSeeder::class);
        $this->seed(\Database\Seeders\LokasiSeeder::class);
        $this->seed(\Database\Seeders\UserSeeder::class);
    }

    public function test_login_success(): void
    {
        $response = $this->postJson('/api/login', [
            'username' => 'kepsek',
            'password' => 'password',
        ]);

        $response->assertStatus(200)
            ->assertJsonStructure([
                'message',
                'data' => ['id', 'username', 'name', 'role'],
            ]);
    }

    public function test_login_failed_wrong_password(): void
    {
        $response = $this->postJson('/api/login', [
            'username' => 'kepsek',
            'password' => 'wrongpassword',
        ]);

        $response->assertStatus(401);
    }

    public function test_me_authenticated(): void
    {
        $user = User::where('username', 'kepsek')->first();

        $response = $this->actingAs($user)->getJson('/api/me');

        $response->assertStatus(200)
            ->assertJsonPath('data.username', 'kepsek')
            ->assertJsonPath('data.role.kode_role', 'KEPSEK');
    }

    public function test_me_unauthenticated(): void
    {
        $response = $this->getJson('/api/me');

        $response->assertStatus(401);
    }

    public function test_logout(): void
    {
        $user = User::where('username', 'kepsek')->first();

        $response = $this->actingAs($user)->postJson('/api/logout');

        $response->assertStatus(200)
            ->assertJson(['message' => 'Logout berhasil.']);
    }

    public function test_check_role_middleware_allowed(): void
    {
        $user = User::where('username', 'kepsek')->first();

        $this->app->make('router')->get('/api/test-role', function () {
            return response()->json(['message' => 'ok']);
        })->middleware('auth:sanctum', 'role:KEPSEK');

        $response = $this->actingAs($user)->getJson('/api/test-role');

        $response->assertStatus(200);
    }

    public function test_check_role_middleware_denied(): void
    {
        $user = User::where('username', 'sarpras')->first();

        $this->app->make('router')->get('/api/test-role', function () {
            return response()->json(['message' => 'ok']);
        })->middleware('auth:sanctum', 'role:KEPSEK');

        $response = $this->actingAs($user)->getJson('/api/test-role');

        $response->assertStatus(403);
    }
}
