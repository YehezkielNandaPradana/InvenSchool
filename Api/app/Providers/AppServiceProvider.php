<?php

namespace App\Providers;

use App\Models\Barang;
use App\Models\KategoriBarang;
use App\Models\KategoriDana;
use App\Models\Lokasi;
use App\Models\MutasiBarang;
use App\Models\User;
use App\Policies\BarangPolicy;
use App\Policies\MasterDataPolicy;
use App\Policies\MutasiBarangPolicy;
use Dedoc\Scramble\Scramble;
use Dedoc\Scramble\Support\Generator\OpenApi;
use Dedoc\Scramble\Support\Generator\SecurityScheme;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Gate;

class AppServiceProvider extends ServiceProvider
{
    protected $policies = [
        Lokasi::class => MasterDataPolicy::class,
        KategoriDana::class => MasterDataPolicy::class,
        KategoriBarang::class => MasterDataPolicy::class,
        Barang::class => BarangPolicy::class,
        MutasiBarang::class => MutasiBarangPolicy::class,
    ];

    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        $this->registerPolicies();

        Scramble::configure()
            ->withDocumentTransformers(function (OpenApi $openApi) {
                $openApi->secure(
                    SecurityScheme::apiKey('cookie', 'laravel_session')
                );
            });

        Gate::define('viewApiDocs', function (?User $user) {
            if (app()->environment('local')) {
                return true;
            }
            return $user && in_array($user?->role?->kode_role, ['KATU', 'KEPSEK']);
        });
    }
}
