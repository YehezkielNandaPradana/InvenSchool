<?php

namespace App\Http\Requests\Master;

use Illuminate\Foundation\Http\FormRequest;

class StoreKategoriDanaRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'kode_dana' => ['required', 'string', 'max:10', 'unique:tbl_kategori_dana,kode_dana'],
            'nama_dana' => ['required', 'string', 'max:100'],
        ];
    }
}
