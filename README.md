# MoneyTrack — Aplikasi Pencatatan Keuangan Pribadi

Aplikasi pencatatan keuangan modern dengan arsitektur **Laravel 11 + Livewire 3** (backend & web), **Flutter** (mobile), dan **MySQL** (database).

---

## 🏗️ Arsitektur

```
MoneyTrack/
├── laravel/     ← Backend API + Livewire Web Dashboard
└── flutter/     ← Mobile App (iOS & Android)
```

---

## ⚙️ Setup Laravel (Backend)

### 1. Clone & Install

```bash
cd laravel
composer install
cp .env.example .env
php artisan key:generate
```

### 2. Konfigurasi `.env`

```env
DB_DATABASE=MoneyTrack
DB_USERNAME=root
DB_PASSWORD=your_password

CACHE_STORE=redis
QUEUE_CONNECTION=redis
```

### 3. Migrasi & Seeder

```bash
php artisan migrate
php artisan db:seed
# Demo: budi@MoneyTrack.id / password123
```

### 4. Storage & Sanctum

```bash
php artisan storage:link
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

### 5. Jalankan Server

```bash
php artisan serve          # API: http://localhost:8000
php artisan queue:work     # Worker untuk PDF export
```

---

## 📱 Setup Flutter (Mobile)

### 1. Install Dependencies

```bash
cd flutter
flutter pub get
```

### 2. Konfigurasi API URL

Edit `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'http://YOUR_SERVER_IP:8000/api/v1';
// Untuk emulator Android: http://10.0.2.2:8000/api/v1
// Untuk device fisik: http://192.168.x.x:8000/api/v1
```

### 3. Jalankan

```bash
flutter run
```

---

## 🔌 API Endpoints

| Method | Endpoint | Auth | Deskripsi |
|--------|----------|------|-----------|
| POST | `/api/v1/register` | — | Daftar akun baru |
| POST | `/api/v1/login` | — | Login, return token |
| POST | `/api/v1/logout` | ✅ | Revoke token |
| GET | `/api/v1/dashboard` | ✅ | Summary + chart + recent |
| GET | `/api/v1/transactions` | ✅ | List transaksi (filter, sort, paginate) |
| POST | `/api/v1/transactions` | ✅ | Buat transaksi |
| PUT | `/api/v1/transactions/{id}` | ✅ | Update transaksi |
| DELETE | `/api/v1/transactions/{id}` | ✅ | Hapus transaksi |
| GET | `/api/v1/transactions/export-pdf` | ✅ | Download PDF |
| GET | `/api/v1/categories` | ✅ | Daftar kategori |
| POST | `/api/v1/categories` | ✅ | Buat kategori kustom |
| GET | `/api/v1/profile` | ✅ | Data profil |
| PUT | `/api/v1/profile` | ✅ | Update profil |
| PUT | `/api/v1/profile/password` | ✅ | Ubah password |
| POST | `/api/v1/profile/photo` | ✅ | Upload foto |

### Contoh Request Login

```bash
curl -X POST http://localhost:8000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"email":"budi@MoneyTrack.id","password":"password123"}'
```

### Contoh Response Dashboard

```json
{
  "summary": {
    "total_income": 9500000,
    "total_expense": 4250000,
    "balance": 5250000,
    "month": 4,
    "year": 2025
  },
  "chart_data": [...],
  "recent": [...]
}
```

---

## 🗂️ Struktur Folder Laravel

```
app/
├── Http/
│   ├── Controllers/Api/
│   │   ├── AuthController.php        ← Login, register, logout
│   │   ├── DashboardController.php   ← Summary + chart
│   │   ├── TransactionController.php ← CRUD + export PDF
│   │   ├── CategoryController.php    ← Manajemen kategori
│   │   └── ProfileController.php    ← Profil + foto
│   ├── Livewire/
│   │   ├── Dashboard.php             ← Real-time dashboard
│   │   └── TransactionList.php      ← CRUD web table
│   ├── Requests/
│   │   ├── StoreTransactionRequest.php
│   │   └── UpdateTransactionRequest.php
│   └── Resources/
│       ├── TransactionResource.php
│       └── UserResource.php
├── Models/
│   ├── User.php
│   ├── Transaction.php
│   └── Category.php
├── Services/
│   ├── DashboardService.php          ← Business logic + caching
│   └── TransactionService.php        ← CRUD + PDF generation
database/
├── migrations/
│   ├── create_users_table.php
│   ├── create_categories_table.php
│   └── create_transactions_table.php
└── seeders/
    └── DatabaseSeeder.php
```

---

## 🗂️ Struktur Folder Flutter

```
lib/
├── core/
│   ├── constants/app_constants.dart  ← URL, keys, colors
│   ├── network/api_client.dart       ← Dio + interceptors
│   ├── router/app_router.dart        ← GoRouter + redirect
│   ├── theme/app_theme.dart          ← Material3 theme
│   └── utils/formatters.dart        ← Currency + date
├── features/
│   ├── auth/
│   │   ├── data/auth_repository.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   ├── dashboard/
│   │   ├── data/dashboard_repository.dart
│   │   └── presentation/dashboard_screen.dart
│   ├── transaction/
│   │   ├── data/transaction_repository_impl.dart
│   │   ├── domain/transaction_entity.dart
│   │   └── presentation/
│   │       ├── transaction_list_screen.dart
│   │       └── transaction_form_screen.dart
│   ├── category/
│   │   └── data/category_repository.dart
│   └── profile/
│       ├── data/profile_repository.dart
│       └── presentation/profile_screen.dart
├── shared/
│   ├── providers/providers.dart      ← Riverpod providers
│   └── widgets/main_scaffold.dart    ← Bottom navigation
└── main.dart
```

---

## ✅ Best Practice yang Diterapkan

### Laravel
- **Service + Repository pattern** — controller hanya routing, business logic di Service
- **API Resource** — response konsisten di semua endpoint
- **FormRequest** — validasi terpisah, reusable
- **Cache** — dashboard summary di-cache 5 menit, auto-invalidate setelah transaksi berubah
- **Sanctum** — stateless auth dengan Bearer token
- **Ownership check** — setiap query filter `where user_id`
- **Rate limiting** — throttle 60 request/menit
- **Queue** — PDF export tidak blocking response

### Flutter
- **Clean Architecture** — `domain → data → presentation`
- **Riverpod** — state management, auto-dispose, error handling
- **GoRouter** — declarative routing + auth redirect
- **Dio Interceptor** — auto-inject token, handle 401 logout
- **Dismissible** — swipe to delete di transaction list
- **RefreshIndicator** — pull-to-refresh dashboard

---

## 🔒 Security Checklist

- [x] Password di-hash dengan bcrypt (Laravel default)
- [x] Sanctum token revoke saat logout
- [x] Ownership validation di setiap endpoint
- [x] Rate limiting 60 req/menit
- [x] CORS konfigurasi via `config/cors.php`
- [x] Validasi input server-side (FormRequest)
- [x] File upload validasi mime type & ukuran
- [x] SQL Injection aman via Eloquent ORM
- [x] Secure storage untuk token di Flutter

---

## 📦 Dependencies Utama

### Laravel
| Package | Versi | Fungsi |
|---------|-------|--------|
| laravel/sanctum | ^4.0 | API authentication |
| livewire/livewire | ^3.4 | Real-time web UI |
| barryvdh/laravel-dompdf | ^2.0 | PDF export |

### Flutter
| Package | Versi | Fungsi |
|---------|-------|--------|
| flutter_riverpod | ^2.4 | State management |
| go_router | ^13.0 | Navigation |
| dio | ^5.4 | HTTP client |
| fl_chart | ^0.66 | Bar chart |
| flutter_secure_storage | ^9.0 | Token storage |
| intl | ^0.19 | Formatting |

---

*MoneyTrack v1.0 — Built with Laravel 11 + Flutter 3*
