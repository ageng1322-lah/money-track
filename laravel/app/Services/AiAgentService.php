<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class AiAgentService
{
    protected $apiKey;
    protected $baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

    public function __construct()
    {
        $this->apiKey = env('GEMINI_API_KEY');
    }

    public function parseTransaction(string $input, array $categories = [])
    {
        if (!$this->apiKey) {
            return [
                'error' => 'API Key Gemini belum dikonfigurasi di .env (GEMINI_API_KEY)'
            ];
        }

        $categoryList = !empty($categories) ? implode(', ', $categories) : 'Makanan, Transport, Belanja, Gaji, Lainnya';

        $systemPrompt = "You are a financial transaction parser.
Extract structured transaction data from user input.
You MUST return ONLY valid JSON with this exact format:
{
  \"amount\": number,
  \"type\": \"income\" | \"expense\",
  \"category\": string,
  \"description\": string,
  \"date\": \"YYYY-MM-DD\"
}
Rules:
- amount: number only (no dots/commas)
- category: use ONE of these names: $categoryList
- type: \"income\" (masuk/gaji) or \"expense\" (keluar/beli/makan)
- description: short summary in Indonesian
- date: YYYY-MM-DD (today is " . now()->format('Y-m-d') . ")

Return ONLY JSON. No explanation. No markdown.";

        try {
            $response = Http::post("{$this->baseUrl}?key={$this->apiKey}", [
                'contents' => [
                    [
                        'parts' => [
                            ['text' => $systemPrompt . "\n\nInput: \"$input\""]
                        ]
                    ]
                ]
            ]);

            if ($response->failed()) {
                Log::error('Gemini API Error: ' . $response->body());
                return ['error' => 'Gagal menghubungi AI. Pastikan API Key di .env sudah benar.'];
            }

            $result = $response->json();
            $text = $result['candidates'][0]['content']['parts'][0]['text'] ?? null;

            if ($text) {
                // Clean up markdown if AI returns it
                $text = trim($text);
                if (strpos($text, '```json') === 0) {
                    $text = substr($text, 7);
                    $text = substr($text, 0, -3);
                } elseif (strpos($text, '```') === 0) {
                    $text = substr($text, 3);
                    $text = substr($text, 0, -3);
                }
                
                return json_decode(trim($text), true);
            }
        } catch (\Exception $e) {
            Log::error('AiAgentService Error: ' . $e->getMessage());
            return ['error' => 'Terjadi kesalahan sistem.'];
        }

        return ['error' => 'AI tidak memberikan respon yang valid.'];
    }
}
