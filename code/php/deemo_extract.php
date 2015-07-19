<?php

/*
 * Extracts most of Deemo's ressource files
 */

$file = @$argv[1] ? : exit;

$fIn = new \SplFileObject($file, 'rb');
$fIn->flock(LOCK_SH);

$offset = 0x1000;
$fIn->fseek($offset);
$resNameLength = current(unpack('l', $fIn->fread(4)));

$offset += 4;
$fIn->fseek($offset);
$resName = trim($fIn->fread($resNameLength), "\x00..\x20") ? : exit;

$offset += $resNameLength;
$fIn->fseek($offset);

for ($inc = 0; $inc < 8; ++$inc) {
    if ($fIn->fread(1) == "\x02") {
        $offset += $inc;
        break;
    }
}

$offset += 0x14;
$fIn->fseek($offset);

while (!$fIn->eof()) {
    fwrite($fOut, fread($fIn, 0x2000));
}
