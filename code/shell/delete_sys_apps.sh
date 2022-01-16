#!/usr/bin/env bash

adb shell pm grant com.maxmpz.audioplayer android.permission.SET_VOLUME_KEY_LONG_PRESS_LISTENER
adb shell pm disable-user --user 0 com.android.bips
adb shell pm disable-user --user 0 com.android.providers.partnerbookmarks
adb shell pm disable-user --user 0 com.google.android.feedback
adb shell pm disable-user --user 0 com.google.android.partnersetup
adb shell pm disable-user --user 0 com.google.android.printservice.recommendation
adb shell pm uninstall --user 0 cn.oneplus.photos
adb shell pm uninstall --user 0 com.android.chrome
adb shell pm uninstall --user 0 com.google.android.apps.tachyon
adb shell pm uninstall --user 0 com.google.android.apps.walletnfcrel
adb shell pm uninstall --user 0 com.google.android.apps.wellbeing
adb shell pm uninstall --user 0 com.google.android.apps.youtube.music
adb shell pm uninstall --user 0 com.google.android.marvin.talkback
adb shell pm uninstall --user 0 com.google.android.music
adb shell pm uninstall --user 0 com.google.android.projection.gearhead
adb shell pm uninstall --user 0 com.google.android.videos
adb shell pm uninstall --user 0 com.google.ar.core
adb shell pm uninstall --user 0 com.oneplus.account
adb shell pm uninstall --user 0 com.oneplus.brickmode
adb shell pm uninstall --user 0 com.oneplus.contacts
adb shell pm uninstall --user 0 com.oneplus.gallery
adb shell pm uninstall --user 0 com.oneplus.gamespace
adb shell pm uninstall --user 0 com.oneplus.mms
adb shell pm uninstall --user 0 com.oneplus.twspods
