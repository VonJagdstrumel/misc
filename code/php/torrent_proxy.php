<?php

/*
 * Take the real tracker URL (e.g. http://example-tracker.net:8000/some-user-key/announce)
 * Remove the trailing '/announce' (e.g. http://example-tracker.net:8000/some-user-key)
 * Encode in Base64 (e.g. aHR0cDovL2V4YW1wbGUtdHJhY2tlci5uZXQ6ODAwMC9zb21lLXVzZXIta2V5)
 * Insert it in 'http://<your_server>/<base64>/announce' (e.g. http://127.0.0.1:8090/aHR0cDovL2V4YW1wbGUtdHJhY2tlci5uZXQ6ODAwMC9zb21lLXVzZXIta2V5/announce)
 * Update your torrents
 */

require 'vendor/autoload.php';

use \GuzzleHttp\Client;
use \GuzzleHttp\Exception\RequestException;

$paramList = $_GET;
foreach($paramList as $key => &$value) {
	switch($key) {
		case 'downloaded':
			$value = '0';
			break;
		case 'peer_id':
			$value = preg_replace('/[^-]+/', 'UT2110', $value, 1);
			break;
	}
}

$requestUrlParts = explode('/', $_SERVER['PHP_SELF']);
$action = array_pop($requestUrlParts);
$baseUrl = base64_decode(array_pop($requestUrlParts));
$queryString = http_build_query($paramList);
$fullUrl = "$baseUrl/$action?$queryString";

$headers = getallheaders();
foreach($headers as $key => &$value) {
	switch($key) {
		case 'User-Agent':
			$value = 'uTorrent/2210(25110)';
			break;
		case 'Host':
			$hostComponents = array_intersect_key(parse_url($fullUrl), ['host' => 0, 'port' => 0]);
			$value = implode(':', $hostComponents);
			break;
	}
}

try {
	$client = new Client();
	$response = $client->request('GET', $fullUrl, [
		'headers' => $headers,
		'decode_content' => false,
		'stream' => true
	]);

	foreach($response->getHeaders() as $headerKey => $headerValueList) {
		foreach($headerValueList as $headerValue) {
			header("$headerKey: $headerValue");
		}
	}
	print $response->getBody()->getContents();
}
catch(RequestException $ex) {
	http_response_code(400);
}
