<?php

/*
 * Patch Portable Executable files and switch from GUI to CUI and vice versa.
 */

$file = @$argv[1] ? : exit;

$fh = new \SplFileObject($file, 'r+b');
$fh->flock(LOCK_EX);

$fh->fseek(0x3c);
$startPos = current(unpack('l', $fh->fread(4))) + 0x5c;

$fh->fseek($startPos);
$subsystem = current(unpack('l', $fh->fread(4)));

if (in_array($subsystem, array(2, 3))) {
    $subsystem = ($subsystem - 1) % 2 + 2;
}

$fh->fseek($startPos);
$fh->fwrite(pack('l', $subsystem));
