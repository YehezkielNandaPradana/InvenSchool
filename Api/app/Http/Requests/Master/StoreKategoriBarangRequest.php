<?php

namespace App\Http\Requests\Master;

use Illuminate\Foundation\Http\FormRequest;

class StoreKategoriBarangRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'kode_kategori' => ['required', 'string', 'max:10', 'unique:tbl_kategori_barang,kode_kategori'],
            'nama_kategori' => ['required', 'string', 'max:100'],
        ];
    }
}
