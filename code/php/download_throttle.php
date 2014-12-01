<?php

/*
 * Limitation de débit pour téléchargement d'un fichier.
 */

// YOU CAN TOUCH THIS SHIT
$remote = @$argv[1] ? : exit;
$local = @$argv[2] ? : exit;
$bandwidth = @$argv[3] ? : exit;

// DON'T TOUCH THIS SHIT NOW
$bufferSize = 8192;
$callsPerSecond = $bandwidth / $bufferSize;
$microSleepTime = 1e6 / $callsPerSecond;

$remoteHandle = fopen($remote, 'r');
$localHandle = fopen($local, 'w+');

while (!feof($remoteHandle)) {
    $buffer = fread($remoteHandle, $bufferSize);
    fwrite($localHandle, $buffer);
    usleep($microSleepTime);
}
