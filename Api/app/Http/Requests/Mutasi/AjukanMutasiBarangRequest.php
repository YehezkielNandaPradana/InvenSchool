<?php

namespace App\Http\Requests\Mutasi;

use Illuminate\Foundation\Http\FormRequest;

class AjukanMutasiBarangRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [];
    }
}
