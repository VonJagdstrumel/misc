#!/bin/bash
# Manual android updater with TWRP support
# Only for Nexus 5 stock images

packageArchive=$(find -name "hammerhead-*.tgz" -type f)
tar -xzf $packageArchive

packageDir=$(find -name "hammerhead-*" -type d)
cd $packageDir

imageArchive=$(find -name "image-hammerhead-*.zip" -type f)
unzip $imageArchive

bootloaderImage=$(find -name "bootloader-hammerhead-*.img" -type f)
fastboot flash bootloader $bootloaderImage
fastboot reboot-bootloader

read -sp "Press return to continue..."

radioImage=$(find -name "radio-hammerhead-*.img" -type f)
fastboot flash radio $radioImage
fastboot reboot-bootloader

read -sp "Press return to continue..."

fastboot flash boot boot.img
fastboot flash cache cache.img
fastboot flash system system.img
#fastboot flash recovery twrp-2.8.6.1-hammerhead.img
fastboot reboot-bootloader

read -sp "Press return to continue..."

echo "Boot to recovery mode"
echo "Mount system partition"
echo "Go to /system"
echo "Rename recovery-from-boot.p to recovery-from-boot.p.bak"
echo "Reboot to system"
echo "Install SuperSU"
echo "Reboot to recovery mode"
echo "Install Xposed"
echo "Reboot to system"
read -sp "Press return to continue..."

cd ..
rm -r $packageDir
