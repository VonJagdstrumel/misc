<?php

/*
 * Patch Portable Executable files and switch from GUI to CUI and vice versa.
 */

$file = @$argv[1] ?: exit();

$fh = new \SplFileObject($file, 'r+b');
$fh->flock(LOCK_EX);

$fh->fseek(0x3c);
$startOffsetBin = $fh->fread(4);
$startPos = unpack('l', $startPosBin)[0] + 0x5c;

$fh->fseek($startPos);
$subsystemBin = $fh->fread(4);
$subsystem = unpack('l', $subsystemBin)[0];

if(in_array($subsystem, [2, 3])) {
	$subsystem = ($subsystem - 1) % 2 + 2;
	$subsystemBin = pack('l', $subsystem);
}

$fh->fseek($startPos);
$fh->fwrite($subsystemBin);
