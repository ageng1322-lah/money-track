<?php

namespace App\Livewire;

use App\Models\Category;
use Illuminate\Support\Facades\Auth;
use Livewire\Component;

class CategoryList extends Component
{
    public bool $showModal = false;
    
    // Form fields
    public string $fName   = '';
    public string $fIcon   = '📁';
    public string $fType   = 'expense';
    public string $fColor  = '#10b981';
    public ?int $editingId = null;

    protected array $rules = [
        'fName'  => 'required|string|max:100',
        'fIcon'  => 'nullable|string|max:10',
        'fType'  => 'required|in:income,expense',
        'fColor' => 'nullable|string|regex:/^#[0-9A-Fa-f]{6}$/',
    ];

    public function openModal(?int $id = null): void
    {
        $this->resetValidation();
        $this->editingId = $id;

        if ($id) {
            $cat = Category::where('user_id', Auth::id())->findOrFail($id);
            $this->fName  = $cat->name;
            $this->fIcon  = $cat->icon ?? '📁';
            $this->fType  = $cat->type;
            $this->fColor = $cat->color ?? '#10b981';
        } else {
            $this->fName  = '';
            $this->fIcon  = '📁';
            $this->fType  = 'expense';
            $this->fColor = '#10b981';
        }

        $this->showModal = true;
    }

    public function save(): void
    {
        $this->validate();

        $data = [
            'user_id' => Auth::id(),
            'name'    => $this->fName,
            'icon'    => $this->fIcon,
            'type'    => $this->fType,
            'color'   => $this->fColor,
        ];

        if ($this->editingId) {
            $cat = Category::where('user_id', Auth::id())->findOrFail($this->editingId);
            $cat->update($data);
            session()->flash('success', 'Kategori diperbarui!');
        } else {
            Category::create($data);
            session()->flash('success', 'Kategori baru ditambahkan!');
        }

        $this->showModal = false;
    }

    public function delete(int $id): void
    {
        $cat = Category::where('user_id', Auth::id())->findOrFail($id);
        
        if ($cat->is_default) {
            session()->flash('error', 'Kategori bawaan tidak bisa dihapus.');
            return;
        }

        $cat->delete();
        session()->flash('success', 'Kategori dihapus.');
    }

    public function render()
    {
        $categories = Category::where('user_id', Auth::id())
            ->orderBy('is_default', 'desc')
            ->orderBy('name', 'asc')
            ->get();

        return view('livewire.category-list', compact('categories'))
            ->layout('layouts.app', ['title' => 'Manajemen Kategori']);
    }
}
