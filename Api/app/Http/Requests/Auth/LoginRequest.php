<?php

namespace App\Http\Requests\Auth;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class LoginRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, ValidationRule|array|string> */
    public function rules(): array
    {
        return [
            'email' => ['required_without:username', 'string', 'max:255'],
            'username' => ['required_without:email', 'string', 'max:50'],
            'password' => ['required', 'string'],
        ];
    }
}
