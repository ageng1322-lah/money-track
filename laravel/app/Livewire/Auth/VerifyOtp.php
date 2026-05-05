<?php

namespace App\Livewire\Auth;

use Livewire\Component;
use Illuminate\Support\Facades\Auth;
use App\Mail\SendOtpMail;
use Illuminate\Support\Facades\Mail;

class VerifyOtp extends Component
{
    public $otp;
    public $error;

    protected $rules = [
        'otp' => 'required|digits:4',
    ];

    public function mount()
    {
        if (!Auth::check()) {
            return redirect()->route('login');
        }

        if (!Auth::user()->otp_code) {
            return redirect()->route('dashboard');
        }
    }

    public function verify()
    {
        $this->validate();

        $user = Auth::user();

        if ($user->otp_code === $this->otp) {
            if (now()->greaterThan($user->otp_expires_at)) {
                $this->error = 'Kode OTP sudah kedaluwarsa. Silakan minta kode baru.';
                return;
            }

            $user->update([
                'otp_code' => null,
                'otp_expires_at' => null,
                'email_verified_at' => now(),
            ]);

            return redirect()->route('dashboard');
        }

        $this->error = 'Kode OTP salah. Silakan coba lagi.';
    }

    public function resend()
    {
        $user = Auth::user();
        $otp = str_pad(random_int(0, 9999), 4, '0', STR_PAD_LEFT);

        $user->update([
            'otp_code' => $otp,
            'otp_expires_at' => now()->addMinutes(10),
        ]);

        Mail::to($user->email)->send(new SendOtpMail($otp));

        session()->flash('message', 'Kode OTP baru telah dikirim ke email Anda.');
    }

    public function render()
    {
        return view('livewire.auth.verify-otp')->layout('layouts.auth');
    }
}
