<?php

/*
 * Analyze a directory tree in order to find custom directories
 */

$path = @$argv[1] ? : '.';
$directory = new RecursiveDirectoryIterator($path);
$iterator = new RecursiveIteratorIterator($directory);
$regex = new RegexIterator($iterator, '/^.+desktop\.ini$/i', RecursiveRegexIterator::GET_MATCH);

foreach ($regex as $item) {
    $fileContent = file_get_contents($item[0]);
    $encoding = mb_detect_encoding($fileContent) ? : 'UCS-2LE';

    if ($encoding == 'UCS-2LE') {
        $fileContent = substr($fileContent, 2);
    }

    $decodedFileContent = mb_convert_encoding($fileContent, 'UTF-8', $encoding);
    $iniContent = parse_ini_string($decodedFileContent);

    if (!empty($iniContent['FolderType'])) {
        printf("%s: %s\n", $item[0], $iniContent['FolderType']);
    }
}
