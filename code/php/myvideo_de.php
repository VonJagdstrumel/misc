<?php

/*
 * Get video URL from www.myvideo.de ID
 */

$id = @$argv[1] ? : exit;
$url = "http://www.myvideo.de/dynamic/get_player_video_xml.php?_countlimit=4&flash_playertype=D&autorun=yes&ds=1&ID=$id&domain=www.myvideo.de";
$masterKey = 'c8407a08b3c71ea418ec9dc662f2a56e40cbd6d5a114aa50fb1e1079e17f2b83';
$key = md5($masterKey . md5($id));

$content = file_get_contents($url);
$hexEncrypted = substr($content, 8);
$binEncrypted = hex2bin($hexEncrypted);
$plainXml = mcrypt_decrypt('arcfour', $key, $binEncrypted, 'stream', '');

$player_config = new SimpleXMLElement($plainXml);
$videoAttributes = $player_config->playlist->videos->video->attributes();
print $videoAttributes['path'] . urldecode($videoAttributes['source']);
