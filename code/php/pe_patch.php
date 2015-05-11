<?php

/*
 * Patch Portable Executable files and switch from GUI to CUI and vice versa.
 */

$file = @$argv[1] ? : exit;

$fh = fopen($file, 'r+b');
flock($fh, LOCK_SH);

fseek($fh, 0x3c);
$startPos = current(unpack('l', fread($fh, 4))) + 0x5c;

fseek($fh, $startPos);
$subsystem = current(unpack('l', fread($fh, 4)));

$subsystem = in_array($subsystem, array(2, 3)) ?
    ($subsystem - 1) % 2 + 2 :
    $subsystem;

fseek($fh, $startPos);
fwrite($fh, pack('l', $subsystem));

fclose($fh);
