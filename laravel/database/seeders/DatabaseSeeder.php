<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Demo user
        $user = User::create([
            'name'     => 'Budi Santoso',
            'email'    => 'budi@fintrack.id',
            'password' => Hash::make('password123'),
        ]);

        // Default categories
        $categories = [
            ['name'=>'Gaji',      'icon'=>'💼','type'=>'income', 'color'=>'#1D9E75'],
            ['name'=>'Freelance', 'icon'=>'💻','type'=>'income', 'color'=>'#0F6E56'],
            ['name'=>'Investasi', 'icon'=>'📈','type'=>'income', 'color'=>'#639922'],
            ['name'=>'Makanan',   'icon'=>'🍔','type'=>'expense','color'=>'#E24B4A'],
            ['name'=>'Transport', 'icon'=>'🚗','type'=>'expense','color'=>'#D85A30'],
            ['name'=>'Belanja',   'icon'=>'🛍️','type'=>'expense','color'=>'#D4537E'],
            ['name'=>'Kesehatan', 'icon'=>'💊','type'=>'expense','color'=>'#378ADD'],
            ['name'=>'Hiburan',   'icon'=>'🎮','type'=>'expense','color'=>'#7F77DD'],
            ['name'=>'Tagihan',   'icon'=>'📄','type'=>'expense','color'=>'#BA7517'],
        ];

        $catModels = [];
        foreach ($categories as $cat) {
            $catModels[$cat['name']] = Category::create(array_merge($cat, [
                'user_id'    => $user->id,
                'is_default' => true,
            ]));
        }

        // Sample transactions — April 2026
        $txData = [
            ['title'=>'Gaji April',         'amount'=>8000000,'type'=>'income', 'cat'=>'Gaji',     'date'=>'2026-04-01'],
            ['title'=>'Freelance desain',    'amount'=>1500000,'type'=>'income', 'cat'=>'Freelance','date'=>'2026-04-03'],
            ['title'=>'Token listrik',       'amount'=>200000, 'type'=>'expense','cat'=>'Tagihan',  'date'=>'2026-04-04'],
            ['title'=>'Netflix',             'amount'=>54000,  'type'=>'expense','cat'=>'Hiburan',  'date'=>'2026-04-05'],
            ['title'=>'Belanja bulanan',     'amount'=>350000, 'type'=>'expense','cat'=>'Belanja',  'date'=>'2026-04-07'],
            ['title'=>'Bensin',              'amount'=>80000,  'type'=>'expense','cat'=>'Transport','date'=>'2026-04-08'],
            ['title'=>'Freelance logo',      'amount'=>500000, 'type'=>'income', 'cat'=>'Freelance','date'=>'2026-04-09'],
            ['title'=>'Makan siang',         'amount'=>45000,  'type'=>'expense','cat'=>'Makanan',  'date'=>'2026-04-10'],
            ['title'=>'Obat flu',            'amount'=>120000, 'type'=>'expense','cat'=>'Kesehatan','date'=>'2026-04-10'],
            ['title'=>'Internet rumah',      'amount'=>250000, 'type'=>'expense','cat'=>'Tagihan',  'date'=>'2026-04-12'],
            ['title'=>'Makan malam keluarga','amount'=>200000, 'type'=>'expense','cat'=>'Makanan',  'date'=>'2026-04-13'],
        ];

        foreach ($txData as $tx) {
            Transaction::create([
                'user_id'     => $user->id,
                'category_id' => $catModels[$tx['cat']]->id,
                'title'       => $tx['title'],
                'amount'      => $tx['amount'],
                'type'        => $tx['type'],
                'date'        => $tx['date'],
            ]);
        }

        $this->command->info("✅ Demo user: budi@fintrack.id / password123");
    }
}
