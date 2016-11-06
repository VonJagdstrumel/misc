<?php

/*
 * Resample a batch of wallpapers
 * Requires nconvert (http://www.xnview.com/fr/nconvert/)
 */

$screenWidth = @$argv[1] ? : exit;
$screenHeight = @$argv[2] ? : exit;

$directoryIterator = new DirectoryIterator('in');
$outDir = 'out';

if (!is_dir($outDir)) {
    mkdir($outDir);
}

foreach ($directoryIterator as $fileEntry) {
    if (!$fileEntry->isDir() && preg_match('/^(png|jpe?g)$/', $fileEntry->getExtension())) {
        $imagePath = $fileEntry->getPathname();
        $imageSize = getimagesize($imagePath);

        if ($imageSize[0] / $imageSize[1] > 16 / 9) {
            print "nconvert -out jpeg -o $outDir\%.jpg -ratio -resize 0 $screenHeight -canvas $screenWidth $screenHeight center \"$imagePath\"\n";
        } else {
            print "nconvert -out jpeg -o $outDir\%.jpg -ratio -resize $screenWidth 0 -canvas $screenWidth $screenHeight center \"$imagePath\"\n";
        }
    }
}
