<?php

/*
 * Analyze a directory tree in order to find custom directories
 */

$path = @$argv[1] ? : '.';
$directory = new RecursiveDirectoryIterator($path);
$iterator = new RecursiveIteratorIterator($directory);
$regex = new RegexIterator($iterator, '/^.+desktop\.ini$/i', RecursiveRegexIterator::GET_MATCH);

for($regex as $item) {
    $fileContent = file_get_contents($item[0]);
    $encoding = mb_detect_encoding($fileContent) ?: 'UCS-2LE';

    if($encoding == 'UCS-2LE') {
        $fileContent = substr($fileContent, 2);
    }

    $fileContent = mb_convert_encoding($fileContent, 'UTF-8', $encoding);
    $fileContent = @parse_ini_string($fileContent);

    if(!empty($fileContent['FolderType'])) {
        print "{$item[0]}: {$fileContent['FolderType']}\n";
    }
}
