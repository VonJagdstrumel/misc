<?php

/*
 * File to base64 data URI transformation
 */

$file = @$argv[1] ? : exit;
$fileInfo = finfo_file(finfo_open(FILEINFO_MIME), $file);
$mimeType = str_replace(' ', '', $fileInfo);
$encodedData = base64_encode(file_get_contents($file));
printf("data:%s;base64,%s\n", $mimeType, $encodedData);
