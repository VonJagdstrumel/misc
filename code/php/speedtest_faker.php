<?php

/*
 * Generate custom tailored test summaries from speedtest.net
 */

require 'vendor/autoload.php';

use \GuzzleHttp\Client;

$dlSpeed = @$argv[1] ? : exit;
$ulSpeed = @$argv[2] ? : exit;
$ping = @$argv[3] ? : exit;

$id = 2231;
$options = [
	'headers' => [
		'Referer' => 'http://c.speedtest.net/flash/speedtest.swf'
	],
	'form_params' => [
		'download' => $dlSpeed,
		'ping' => $ping,
		'upload' => $ulSpeed,
		'promo' => '',
		'startmode' => 'pingselect',
		'recommendedserverid' => $id,
		'accuracy' => 1,
		'serverid' => $id,
		'hash' => md5("$ping-$ulSpeed-$dlSpeed-297aae72")
	]
];

$client = new Client();
$response = $client->request('POST', 'http://www.speedtest.net/api/api.php', $options);
parse_str($response->getBody(), $queryStringArgs);
echo "http://www.speedtest.net/result/{$queryStringArgs['resultid']}.png\n";
