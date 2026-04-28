<?php

namespace App\Livewire\Admin;

use App\Models\Category;
use Livewire\Component;
use Livewire\WithPagination;

class CategoryManagement extends Component
{
    use WithPagination;

    public $name;
    public $icon = '💰';
    public $type = 'expense';
    public $color = '#10b981';
    public $is_editing = false;
    public $editing_id;
    public $search = '';

    protected $rules = [
        'name' => 'required|min:3',
        'icon' => 'required',
        'type' => 'required|in:income,expense',
        'color' => 'required',
    ];

    public function resetFields()
    {
        $this->name = '';
        $this->icon = '💰';
        $this->type = 'expense';
        $this->color = '#10b981';
        $this->is_editing = false;
        $this->editing_id = null;
    }

    public function create()
    {
        $this->validate();

        Category::create([
            'name' => $this->name,
            'icon' => $this->icon,
            'type' => $this->type,
            'color' => $this->color,
            'is_default' => true,
            'user_id' => null, // Default categories don't belong to a user
        ]);

        $this->resetFields();
        session()->flash('message', 'Default category created successfully.');
    }

    public function edit($id)
    {
        $category = Category::findOrFail($id);
        $this->editing_id = $id;
        $this->name = $category->name;
        $this->icon = $category->icon;
        $this->type = $category->type;
        $this->color = $category->color;
        $this->is_editing = true;
    }

    public function update()
    {
        $this->validate();

        $category = Category::findOrFail($this->editing_id);
        $category->update([
            'name' => $this->name,
            'icon' => $this->icon,
            'type' => $this->type,
            'color' => $this->color,
        ]);

        $this->resetFields();
        session()->flash('message', 'Default category updated successfully.');
    }

    public function delete($id)
    {
        Category::findOrFail($id)->delete();
        session()->flash('message', 'Default category deleted.');
    }

    public function render()
    {
        return view('livewire.admin.category-management', [
            'categories' => Category::where('is_default', true)
                ->where('name', 'like', '%' . $this->search . '%')
                ->latest()
                ->paginate(10)
        ])->layout('layouts.admin');
    }
}
