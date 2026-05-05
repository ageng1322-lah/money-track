<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Kode OTP Anda</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: #ffffff;
            max-width: 600px;
            margin: 40px auto;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            text-align: center;
        }
        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #10b981;
            margin-bottom: 20px;
        }
        h1 {
            color: #1f2937;
            font-size: 20px;
            margin-bottom: 10px;
        }
        p {
            color: #6b7280;
            font-size: 16px;
            line-height: 1.5;
        }
        .otp-box {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            font-size: 36px;
            font-weight: bold;
            letter-spacing: 10px;
            padding: 20px;
            margin: 30px auto;
            border-radius: 8px;
            display: inline-block;
            box-shadow: 0 10px 20px rgba(16, 185, 129, 0.2);
        }
        .footer {
            margin-top: 30px;
            font-size: 12px;
            color: #9ca3af;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Money Track</div>
        <h1>Verifikasi Akun Anda</h1>
        <p>Terima kasih telah mendaftar di Money Track. Gunakan kode OTP di bawah ini untuk memverifikasi akun Anda:</p>
        <div class="otp-box">{{ $otp }}</div>
        <p>Kode ini hanya berlaku selama 10 menit. Jika Anda tidak merasa melakukan pendaftaran ini, silakan abaikan email ini.</p>
        <div class="footer">
            &copy; {{ date('Y') }} Money Track. All rights reserved.
        </div>
    </div>
</body>
</html>
