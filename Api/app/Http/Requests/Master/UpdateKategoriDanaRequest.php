<?php

namespace App\Http\Requests\Master;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateKategoriDanaRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'kode_dana' => ['required', 'string', 'max:10', Rule::unique('tbl_kategori_dana', 'kode_dana')->ignore($this->route('kategori_dana'))],
            'nama_dana' => ['required', 'string', 'max:100'],
        ];
    }
}
