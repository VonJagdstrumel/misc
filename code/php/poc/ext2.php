<?php

// Ext2/3 filesystems have 15 address fields per inode whose first 12 refers to data blocks
$inodeDataFieldsCount = 12;

// Addresses count capacity for each block
$addressesPerBlock = 1024 / 4;

// File size in byte
$fileSize = @$argv[1] ?: exit;

// Data blocks count required for the file
$dataBlocksCount = ceil($fileSize / 1024);

// Address blocks count required for the file
$addressBlocksCount = 1; // Always at least one block used for inode

$remainingBlocks = $dataBlocksCount - $inodeDataFieldsCount;

// Use the 13th inode's address field wich is a one-level indirection
if($remainingBlocks > 0) {
    // Add indirection block
    ++$addressBlocksCount;
}

$remainingBlocks = $dataBlocksCount - $inodeDataFieldsCount - $addressesPerBlock;

// Use the 14th inode's address field wich is a two-levels indirection
if($remainingBlocks > 0) {
    // Add first-level indirection block
    ++$addressBlocksCount;

    // Add every second-level indirection blocks needed
    $addressBlocksCount += min($addressesPerBlock, ceil(($remainingBlocks + $inodeDataFieldsCount) / $addressesPerBlock));
}

$remainingBlocks = $dataBlocksCount - $inodeDataFieldsCount - $addressesPerBlock - $addressesPerBlock ** 2;

// Use the 15th inode's address field wich is a two-levels indirection
if($remainingBlocks > 0) {
    // Add first-level indirection block
    ++$addressBlocksCount;
    
    // Add every second-level indirection blocks needed
    $addressBlocksCount += min($addressesPerBlock, ceil(ceil($remainingBlocks / $addressesPerBlock) / $addressesPerBlock));
    
    // Add every third-level indirection blocks needed
    $addressBlocksCount += min($addressesPerBlock ** 2, ceil($remainingBlocks / $addressesPerBlock));
}

print $dataBlocksCount + $addressBlocksCount;
