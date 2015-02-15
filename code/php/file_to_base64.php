<?php

/*
 * File to base64 container transformation
 */

$file = @$argv[1] ? : exit;
$mimeType = str_replace(str_split(" \t\n\r\0\x0B"), '', finfo_file(finfo_open(FILEINFO_MIME), $file));
$encodedData = base64_encode(file_get_contents($file));
print "data:$mimeType;base64,$encodedData";
