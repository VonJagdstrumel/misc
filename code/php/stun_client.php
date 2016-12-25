<?php

/*
 * Fetch WAN IPv4 from STUN server
 */

function getPublicAddress() {
	$sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
	$host = gethostbyname('stun.l.google.com');
	$port = 19302;
	
	$magic = 0x2112A442;
	$message = pack('NNa12', 0x10000, $magic, '');
	$length = strlen($message);
	
	socket_sendto($sock, $message, $length, 0, $host, $port);
	socket_recvfrom($sock, $buf, 40, 0, $_, $_);
	socket_close($sock);
	
	$xorAddr = substr($buf, 28, 4);
	$decAddr = unpack('N', $xorAddr)[1] ^ $magic;
	return long2ip($decAddr);
}

print getPublicAddress() . "\n";
