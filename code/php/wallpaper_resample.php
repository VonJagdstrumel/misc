<?php

/*
 * Resample a batch of wallpapers
 */

$screenWidth = @$argv[1] ? : exit;
$screenHeight = @$argv[2]? : exit;

$directoryIterator = new DirectoryIterator('In');
$outDir = 'Out';

if (!is_dir($outDir)) {
    mkdir($outDir);
}

foreach ($directoryIterator as $fileEntry) {
    if (!$fileEntry->isDir() && preg_match('/^(png|jpe?g)$/', $fileEntry->getExtension())) {
        $imagePath = $fileEntry->getPathname();
        $imageSize = getimagesize($imagePath);

        if ($imageSize[0] / $imageSize[1] > 16 / 9) {
            print "nconvert -size 256x256+0 -ctype rgb -out jpeg -o $outDir\%%.jpg -ratio -rtype lanczos -resize 0 $screenHeight -canvas $screenWidth $screenHeight center \"$imagePath\"\n";
        } else {
            print "nconvert -size 256x256+0 -ctype rgb -out jpeg -o $outDir\%%.jpg -ratio -rtype lanczos -resize $screenWidth 0 -canvas $screenWidth $screenHeight center \"$imagePath\"\n";
        }
    }
}
