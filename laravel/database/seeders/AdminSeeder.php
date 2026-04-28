<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $user = \App\Models\User::first();
        
        if ($user) {
            $user->update(['role' => 'admin']);
            $this->command->info("User {$user->email} has been promoted to Admin.");
        } else {
            \App\Models\User::create([
                'name' => 'Super Admin',
                'email' => 'admin@moneytrack.test',
                'password' => \Illuminate\Support\Facades\Hash::make('password'),
                'role' => 'admin',
            ]);
            $this->command->info("Default Admin user created: admin@moneytrack.test / password");
        }
    }
}
