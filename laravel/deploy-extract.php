<?php
$zip = new ZipArchive;
$file = __DIR__ . '/vendor.zip';
if ($zip->open($file) === TRUE) {
    $zip->extractTo(__DIR__);
    $zip->close();
    unlink($file);
    unlink(__FILE__);
    echo 'OK';
} else {
    http_response_code(500);
    echo 'FAILED';
}
