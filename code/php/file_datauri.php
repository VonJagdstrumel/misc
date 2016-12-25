<?php

/*
 * File to base64 data URI transformation
 */

$file = @$argv[1] ?: exit;
$fileInfo = new finfo(FILEINFO_MIME);
$mimeType = str_replace(' ', '', $fileInfo->file($file));
$encodedData = base64_encode(file_get_contents($file));
echo "data:$mimeType;base64,$encodedData\n";
