<?php

namespace App\Http\Requests\Master;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateLokasiRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'kode_lokasi' => ['required', 'string', 'max:10', Rule::unique('tbl_lokasi', 'kode_lokasi')->ignore($this->route('lokasi'))],
            'nama_lokasi' => ['required', 'string', 'max:100'],
            'jenis_lokasi' => ['required', 'string', 'in:Prodi,Unit Kerja,Gudang'],
        ];
    }
}
