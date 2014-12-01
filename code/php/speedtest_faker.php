<?php

/*
 * Permet de générer des résultats de tests arbitraires sur speedtest.net
 */

$dlSpeed = @$argv[1] ? : exit;
$ulSpeed = @$argv[2] ? : exit;
$ping = @$argv[3] ? : exit;
$id = 2231;
$apiData = array(
    'download' => $dlSpeed,
    'ping' => $ping,
    'upload' => $ulSpeed,
    'promo' => '',
    'startmode' => 'pingselect',
    'recommendedserverid' => $id,
    'accuracy' => 1,
    'serverid' => $id,
    'hash' => md5("$ping-$ulSpeed-$dlSpeed-297aae72")
);
$options = array(
    'http' => array(
        'method' => 'POST',
        'header' => "Referer: http://c.speedtest.net/flash/speedtest.swf\r\nContent-type: application/x-www-form-urlencoded\r\n",
        'content' => http_build_query($apiData)
    )
);
$response = file_get_contents('http://www.speedtest.net/api/api.php', false, stream_context_create($options));
parse_str($response, $queryStringArgs);
print "http://www.speedtest.net/result/${queryStringArgs['resultid']}.png";
