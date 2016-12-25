<?php

/*
 * Resample a batch of wallpapers
 * Requires nconvert (http://www.xnview.com/fr/nconvert/)
 */

$canvasWidth = @$argv[1] ?: exit();
$canvasHeight = @$argv[2] ?: exit();
$srcDir = @$argv[3] ?: '.';
$dstDir = @$argv[4] ?: 'out';

if(!is_dir($dstDir)) {
	mkdir($dstDir);
}

$fileList = new FilesystemIterator($srcDir);

foreach($fileList as $fileEntry) {
	if(!$fileEntry->isDir() && preg_match('/^(png|jpe?g)$/', $fileEntry->getExtension())) {
		$srcPath = $fileEntry->getPathname();
		list($srcWidth, $srcHeight) = getimagesize($srcPath);
		
		// Too wide
		if($srcWidth / $srcHeight > 16 / 9) {
			$dstWidth = 0;
			$dstHeight = $canvasHeight;
		} else {
			$dstWidth = $canvasWidth;
			$dstHeight = 0;
		}
		
		system("nconvert -out jpeg -o $dstDir\%.jpg -ratio -resize $dstWidth $dstHeight -canvas $canvasWidth $canvasHeight center '$srcPath'");
	}
}
