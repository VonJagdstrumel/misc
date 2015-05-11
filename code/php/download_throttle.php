<?php

/*
 * Apply throttle on the download of a file
 */

$remote = @$argv[1] ? : exit;
$local = @$argv[2] ? : exit;
$bandwidth = @$argv[3] ? : exit;

$bufferSize = 8192;
$callsPerSecond = $bandwidth / $bufferSize;
$microSleepTime = 1e6 / $callsPerSecond;

$remoteHandle = fopen($remote, 'rb');
$localHandle = fopen($local, 'wb');

flock($remoteHandle, LOCK_SH);
flock($localHandle, LOCK_EX);

while (!feof($remoteHandle)) {
    $buffer = fread($remoteHandle, $bufferSize);
    fwrite($localHandle, $buffer);
    usleep($microSleepTime);
}

fclose($remoteHandle);
fclose($localHandle);
