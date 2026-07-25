<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateBarangRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'nama_barang' => ['required', 'string', 'max:200'],
            'spesifikasi' => ['nullable', 'string'],
            'kategori_dana_id' => ['required', 'integer', 'exists:tbl_kategori_dana,id'],
            'kategori_barang_id' => ['required', 'integer', 'exists:tbl_kategori_barang,id'],
            'lokasi_id' => ['required', 'integer', 'exists:tbl_lokasi,id'],
            'kondisi_umum' => ['nullable', 'string', 'in:Baik,Rusak Ringan,Rusak Berat'],
        ];
    }
}
