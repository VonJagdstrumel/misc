<?php
require 'vendor/autoload.php';

use \GuzzleHttp\Client;

class SessionRequest {

	public $app_id;

	public $password;

	function __construct(string $challenge) {
		$appToken = 'APP_TOKEN';
		$this->app_id = 'APP_ID';
		$this->password = hash_hmac('sha1', $challenge, $appToken);
	}
}

$addrList = PHP_SAPI == 'cli' ? gethostbynamel(gethostname()) : [$_SERVER['REMOTE_ADDR']];
$baseUrl = 'http://mafreebox.freebox.fr/api/v3';
$client = new Client();

$response = $client->request('GET', "$baseUrl/login/");
$jsonObject = json_decode($response->getBody());

$sessionRequest = new SessionRequest($jsonObject->result->challenge);
$response = $client->request('POST', "$baseUrl/login/session/", ['json' => $sessionRequest]);
$jsonObject = json_decode($response->getBody());

$headers = ['X-Fbx-App-Auth' => $jsonObject->result->session_token];
$response = $client->request('GET', "$baseUrl/fw/redir/", ['headers' => $headers]);
$jsonObject = json_decode($response->getBody());

foreach($jsonObject->result as $item) {
	if($item->enabled && in_array($item->lan_ip, $addrList)) {
		$host = $item;
		break;
	}
}
echo "{$host->ip_proto}: {$host->wan_port_start} - {$host->wan_port_end}\n";

$client->request('POST', "$baseUrl/login/logout/", ['headers' => $headers]);
