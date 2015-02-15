<?php

/*
 * Extracts most of Deemo's ressource files
 */

$file = @$argv[1] ? : exit;

$fIn = fopen(@$argv[1], 'r');
flock($fIn, LOCK_SH);

$offset = 0x1000;
fseek($fIn, $offset);
$resNameLength = unpack('i', fread($fIn, 4))[1];

$offset += 0x4;
fseek($fIn, $offset);
$resName = trim(@fread($fIn, $resNameLength), "\x00..\x20") ? : exit;

$offset += $resNameLength;
fseek($fIn, $offset);

for($inc = 0; $inc < 8; ++$inc) {
    if(fread($fIn, 1) == "\x02") {
        $offset += $inc;
        break;
    }
}

$offset += 0x14;
fseek($fIn, $offset);

$fOut = fopen($resName . '.bin', 'w');
flock($fOut, LOCK_EX);

while(!feof($fIn)) {
    fwrite($fOut, fread($fIn, 0x2000));
}

fclose($fIn);
fclose($fOut);
