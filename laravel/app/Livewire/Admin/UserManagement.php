<?php

namespace App\Livewire\Admin;

use Livewire\Component;
use App\Models\User;
use Livewire\WithPagination;

class UserManagement extends Component
{
    use WithPagination;

    public $search = '';

    public function updatingSearch()
    {
        $this->resetPage();
    }

    public function updateRole($userId, $newRole)
    {
        $user = User::find($userId);
        if ($user && $user->id !== auth()->id()) {
            $user->update(['role' => $newRole]);
            session()->flash('message', 'Role updated successfully.');
        }
    }

    public function deleteUser($userId)
    {
        $user = User::find($userId);
        if ($user && $user->id !== auth()->id()) {
            $user->delete();
            session()->flash('message', 'User deleted successfully.');
        }
    }

    public function render()
    {
        $users = User::where('name', 'like', '%' . $this->search . '%')
            ->orWhere('email', 'like', '%' . $this->search . '%')
            ->orderBy('created_at', 'desc')
            ->paginate(10);

        return view('livewire.admin.user-management', [
            'users' => $users
        ])->layout('layouts.admin');
    }
}
