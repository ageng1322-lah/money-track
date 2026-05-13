<?php
use Illuminate\Support\Facades\Http;

require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';

$response = Http::post('http://127.0.0.1:8000/api/v1/verify-otp', [
    'otp' => '1234'
]);

echo "Status: " . $response->status() . "\n";
echo "Body: " . $response->body() . "\n";
