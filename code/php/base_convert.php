<?php

$fromTo = @$argv[1] ? : exit(1);
$rawValue = @$argv[2] ? : exit(1);

if (strlen($fromTo) != 2 || $fromTo[0] == $fromTo[1]) {
    exit(1);
}

switch ($fromTo[0]) {
    case 'b':
        $value = bindec($rawValue);
        break;
    case 'd':
        $value = intval($rawValue);
        break;
    case 'o':
        $value = octdec($rawValue);
        break;
    case 'x':
        $value = hexdec($rawValue);
        break;
    default:
        exit(1);
}

if(strstr('bdox', $fromTo[1]) === false) {
	exit(1);
}

printf("%{$fromTo[1]}\n", $value);
