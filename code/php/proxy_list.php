<?php

/*
 * Proxy list aggregator from www.xroxy.com and www.samair.ru
 */

for ($i = 0; $i < 220; ++$i) {
    $pageContent = file_get_contents("http://www.xroxy.com/proxylist.php?pnum=$i");
    preg_match_all('/&host=([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})&port=([0-9]{1,5})&/', $pageContent, $proxies, PREG_SET_ORDER);

    foreach ($proxies as $proxy) {
        echo "{$proxy[1]}:{$proxy[2]}\n";
    }
}

for ($i = 1; $i < 16; ++$i) {
    $pageContent = file_get_contents('http://www.samair.ru/proxy/proxy-' . sprintf('%02d', $i) . '.htm');
    preg_match_all('/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[0-9]{1,5}) /', $pageContent, $proxies, PREG_SET_ORDER);

    foreach ($proxies as $proxy) {
        echo "{$proxy[1]}\n";
    }
}
