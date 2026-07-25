<?php

namespace App\Http\Requests\Master;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateKategoriBarangRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'kode_kategori' => ['required', 'string', 'max:10', Rule::unique('tbl_kategori_barang', 'kode_kategori')->ignore($this->route('kategori_barang'))],
            'nama_kategori' => ['required', 'string', 'max:100'],
        ];
    }
}
