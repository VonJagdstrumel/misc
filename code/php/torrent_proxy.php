<?php

/*
 * Launch using 'php -S 127.0.0.1:8090 torrent_proxy.php'
 * Take the real tracker URL without the trailing 'announce' (e.g. http://example-tracker.net:8000/some-user-key/announce.php becomes http://example-tracker.net:8000/some-user-key/)
 * Encode in Base64 (e.g. aHR0cDovL2V4YW1wbGUtdHJhY2tlci5uZXQ6ODAwMC9zb21lLXVzZXIta2V5Lw)
 * Insert it in 'http://127.0.0.1:8090/<base64_encoded_tracker_url>/announce' (e.g. http://127.0.0.1:8090/aHR0cDovL2V4YW1wbGUtdHJhY2tlci5uZXQ6ODAwMC9zb21lLXVzZXIta2V5Lw/announce)
 * Use that URL in your torrents and remove the real one
 */

$requestUrlParts = explode('/', $_SERVER['PHP_SELF']);
$trackerUrl = base64_decode($requestUrlParts[1]) . $requestUrlParts[2] . '?';
$opts = array(
    'http' => array(
        'header' => "User-Agent: uTorrent/2210(25110)\r\nAccept-Encoding: gzip\r\nConnection: Close\r\n"
    )
);

foreach ($_GET as $getKey => $getValue) {
    switch ($getKey) {
        case 'downloaded':
            $getValue = '0';
            break;
        case 'peer_id':
            $getValue = preg_replace('/^-[^-]+/', '-UT2110', $getValue);
            break;
    }

    $trackerUrlParts[] = rawurlencode($getKey) . '=' . rawurlencode($getValue);
}

print file_get_contents($trackerUrl . implode('&', $trackerUrlParts), false, stream_context_create($opts));
