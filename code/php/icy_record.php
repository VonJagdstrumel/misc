<?php

/*
 * Provide basic ICY support for stream recording
 * Currently optimized for Armitage's Dimension stream but this should work for any other stream
 */

// Server definition
$server = @$argv[1] ? : 'radio1.com-community.com:9010';
$parsedServer = parse_url($server);

// Request server for audio stream
$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
socket_connect($socket, $parsedServer['host'], $parsedServer['port']);
socket_write($socket, "GET / HTTP/1.0\r\nIcy-MetaData:1\r\n\r\n");

// Response headers buffer
$response = '';

// Header reader
for (;;) {
    // Read byte
    socket_recv($socket, $buffer, 1, MSG_WAITALL);
    $response .= $buffer;

    // On end of headers
    if (substr($response, -4) == "\x0d\x0a\x0d\x0a") {
        // Extract meta interval value
        preg_match("/icy-metaint:([0-9]+)\r\n/", $response, $matches);
        $metaInterval = $matches[1];
        break;
    }
}

// Stream reader
for (;;) {
    // Get stream data then try to output to file
    socket_recv($socket, $buffer, $metaInterval, MSG_WAITALL);
    if (!empty($fh)) {
        $fh->fwrite($buffer);
    }

    // Get meta block size
    socket_recv($socket, $buffer, 1, MSG_WAITALL);
    $blockSize = ord($buffer) * 16;

    // On non-empty meta block
    if ($blockSize) {
        // Read meta block data then extract current song title
        socket_recv($socket, $buffer, $blockSize, MSG_WAITALL);
        preg_match("/StreamTitle='(.*?)';/", $buffer, $matches);

        // Split album name and track title then normalize strings
        $names = explode(':', $matches[1], 2);
        $names[0] = trim(preg_replace('/[\/\\\\:*?"<>|]/', '_', $names[0]));
        $names[1] = trim(preg_replace('/[\/\\\\:*?"<>|]/', '_', $names[1]));

        // Try to close previous output file
        $fh = null;

        // Open a new one
        @mkdir($names[0]);
        $fh = new \SplFileObject($names[0] . DIRECTORY_SEPARATOR . $names[1] . '.mp3', 'wb');
        $fh->flock(LOCK_EX);
    }
}
