<?php

/*
 * Apply throttle on the download of a file
 */

$remote = @$argv[1] ? : exit;
$local = @$argv[2] ? : exit;
$bandwidth = @$argv[3] ? : exit;

$bufferSize = 0x2000;
$callsPerSecond = $bandwidth / $bufferSize;
$microSleepTime = 1e6 / $callsPerSecond;

$remoteHandle = new \SplFileObject($remote, 'rb');
$localHandle = new \SplFileObject($local, 'wb');

$remoteHandle->flock(LOCK_SH);
$localHandle->flock(LOCK_EX);

while (!$remoteHandle->eof()) {
    $buffer = $remoteHandle->fread($bufferSize);
    $localHandle->fwrite($buffer);
    usleep($microSleepTime);
}
