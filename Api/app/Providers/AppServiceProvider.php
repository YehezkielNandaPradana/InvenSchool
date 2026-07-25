<?php

namespace App\Providers;

use App\Models\KategoriBarang;
use App\Models\KategoriDana;
use App\Models\Lokasi;
use App\Policies\MasterDataPolicy;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    protected $policies = [
        Lokasi::class => MasterDataPolicy::class,
        KategoriDana::class => MasterDataPolicy::class,
        KategoriBarang::class => MasterDataPolicy::class,
    ];

    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        $this->registerPolicies();
    }
}
