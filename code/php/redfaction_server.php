<?php

/*
 * Red Faction minimal server implementation
 */

function printLog($msg)
{
    echo "[" . date('H:i:s') . "] $msg\r\n";
}

function cString($string)
{
    return "$string\0";
}

define('DGRAM_TRACKER_ANNOUNCE', 0);
define('DGRAM_CLIENT_QUERY', 1);
define('DGRAM_SERVER_DESCRIBE', 2);
define('DGRAM_CLIENT_JOIN', 3);
define('DGRAM_SERVER_MAP', 4);

define('GAME_TYPE_DM', 0);
define('GAME_TYPE_CTF', 1);
define('GAME_TYPE_TDM', 2);

define('SERVER_FLAG_DEDICATED', 0b001);
define('SERVER_FLAG_PUBLIC', 0b010);
define('SERVER_FLAG_PROTECTED', 0b100);

$configArray = array(
    'tracker' => array(
        'address' => '184.69.54.18',
        'port' => 18444
    ),
    'server' => array(
        'address' => getHostByName(getHostName()),
        'port' => 38554,
        'name' => 'Experimental UltraFap Server',
        'map' => 'Sandwichland',
        'type' => GAME_TYPE_CTF,
        'players' => 27,
        'maxplayers' => 32,
        'mod' => '',
        'status' => SERVER_FLAG_DEDICATED | SERVER_FLAG_PUBLIC,
        'mapfile' => 'ctf01.rfl'
    )
);

$packets[DGRAM_TRACKER_ANNOUNCE] = "\x02\x06\x04\x00\x00\x00\x00\x00\x0A\x00\x00";
$packets[DGRAM_CLIENT_QUERY] = "\x00\x00\x00\x00";
$packets[DGRAM_SERVER_DESCRIBE] = "\x00\x01" .
    chr(8 + strlen($configArray['server']['name'] . $configArray['server']['map'] . $configArray['server']['mod'])) .
    "\x00\x89" .
    cString($configArray['server']['name']) .
    chr($configArray['server']['type']) .
    chr($configArray['server']['players']) .
    chr($configArray['server']['maxplayers']) .
    cString($configArray['server']['map']) .
    cString($configArray['server']['mod']) .
    chr($configArray['server']['status']) .
    "\xDE\xAD\xBE\xEF\xDF\x30";
$packets[DGRAM_CLIENT_JOIN] = "\x00\x02";
$packets[DGRAM_SERVER_MAP] = "\x00\x03\x23\x00" . $configArray['server']['mapfile'] . "\x00\x98\xA5\x06\xF1\x01\x00\x00\x00\x12\x24\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";

$time = 0;
$sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
socket_bind($sock, $configArray['server']['address'], $configArray['server']['port']);

for (;;) {
    if ($time < time()) {
        printLog("Tracker Update");
        $time = time() + 100;
        socket_sendto($sock, $packets[DGRAM_TRACKER_ANNOUNCE], strlen($packets[DGRAM_TRACKER_ANNOUNCE]), 0, $configArray['tracker']['address'], $configArray['tracker']['port']);
    }

    if (socket_recvfrom($sock, $buf, 2 ** 16, 0, $from, $port) !== false) {
        if ($buf == $packets[DGRAM_CLIENT_QUERY]) {
            printLog("<$from> Client Query");
            socket_sendto($sock, $packets[DGRAM_SERVER_DESCRIBE], strlen($packets[DGRAM_SERVER_DESCRIBE]), 0, $from, $port);
        }

        if (substr($buf, 0, 2) == $packets[3]) {
            printLog("<$from> Client Join - " . strtok(substr($buf, 5), "\x00"));
            socket_sendto($sock, $packets[DGRAM_SERVER_MAP], strlen($packets[DGRAM_SERVER_MAP]), 0, $from, $port);
        }
    }

    usleep(100);
}
