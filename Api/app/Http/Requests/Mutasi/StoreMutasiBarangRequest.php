<?php

namespace App\Http\Requests\Mutasi;

use Illuminate\Foundation\Http\FormRequest;

class StoreMutasiBarangRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'lokasi_asal_id' => ['required', 'integer', 'exists:tbl_lokasi,id', 'different:lokasi_tujuan_id'],
            'lokasi_tujuan_id' => ['required', 'integer', 'exists:tbl_lokasi,id'],
            'keterangan' => ['nullable', 'string'],
            'butuh_approval_kepsek' => ['sometimes', 'boolean'],
        ];
    }
}
