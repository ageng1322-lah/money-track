<?php

namespace App\Livewire\Admin;

use Livewire\Component;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Livewire\WithFileUploads;

class Profile extends Component
{
    use WithFileUploads;

    public $name;
    public $email;
    public $password;
    public $password_confirmation;
    public $photo;

    public function mount()
    {
        $user = auth()->user();
        $this->name = $user->name;
        $this->email = $user->email;
    }

    public function updateProfile()
    {
        $this->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . auth()->id(),
        ]);

        $user = auth()->user();
        $user->update([
            'name' => $this->name,
            'email' => $this->email,
        ]);

        session()->flash('message', 'Profile updated successfully.');
    }

    public function updatePassword()
    {
        $this->validate([
            'password' => 'required|min:8|confirmed',
        ]);

        auth()->user()->update([
            'password' => Hash::make($this->password),
        ]);

        $this->password = '';
        $this->password_confirmation = '';

        session()->flash('password_message', 'Password updated successfully.');
    }

    public function render()
    {
        return view('livewire.admin.profile')->layout('layouts.admin');
    }
}
