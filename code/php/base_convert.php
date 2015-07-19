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

switch ($fromTo[1]) {
    case 'b':
    case 'd':
    case 'o':
    case 'x':
        $format = "%{$fromTo[1]}";
        break;
    default:
        exit(1);
}

printf($format, $value);
