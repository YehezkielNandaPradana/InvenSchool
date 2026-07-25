<?php

namespace App\Http\Requests\Mutasi;

use Illuminate\Foundation\Http\FormRequest;

class AddMutasiDetailRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'barang_id' => ['required', 'integer', 'exists:tbl_barang,id'],
            'jumlah' => ['required', 'integer', 'min:1'],
        ];
    }
}
