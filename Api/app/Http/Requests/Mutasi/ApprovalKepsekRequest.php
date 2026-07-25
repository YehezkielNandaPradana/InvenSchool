<?php

namespace App\Http\Requests\Mutasi;

use Illuminate\Foundation\Http\FormRequest;

class ApprovalKepsekRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'status' => ['required', 'string', 'in:Approved,Rejected'],
            'catatan' => ['nullable', 'string'],
        ];
    }
}
