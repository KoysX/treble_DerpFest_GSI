#!/bin/bash

echo
echo "--------------------------------------"
echo "        DerpFest AOSP 14.0 Build    "
echo "                 by                   "
echo "                KoysX               "
echo "        Origin author: ponces  "
echo "--------------------------------------"
echo

set -e

BL=$PWD/treble_DerpFest_GSI
BD=$PWD/treble_DerpFest_GSI/GSI

initRepos() {
    if [ ! -d .repo ]; then
        echo "--> Initializing workspace"
        repo init -u https://github.com/DerpFest-AOSP/manifest.git -b 14 --git-lfs
        echo

        echo "--> Preparing local manifest"
        mkdir -p .repo/local_manifests
        cp $BL/manifest.xml .repo/local_manifests/dp.xml
        echo
    fi
}

syncRepos() {
    echo "--> Syncing repos"
    repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j8
    echo
}

applyPatches() {
    echo "--> Applying phh patches"
    bash $BL/apply-patches.sh $BL phh
    echo

    echo "--> Applying misc patches"
    bash $BL/apply-patches.sh $BL misc
    echo

    echo "--> Generating makefiles"
    cd device/phh/treble
    cp $BL/derp.mk .
    bash generate.sh derp
    cd ../../..
    echo
}

setupEnv() {
    echo "--> Setting up build environment"
    source build/envsetup.sh &>/dev/null
    mkdir -p $BD
    echo
}

buildTrebleApp() {
    echo "--> Building treble_app"
    cd treble_app
    bash build.sh release
    cp TrebleApp.apk ../vendor/hardware_overlay/TrebleApp/app.apk
    cd ..
    echo
}

buildVariant() {
    echo "--> Building treble_arm64_bvN"
    lunch treble_arm64_bvN-userdebug
    make -j$(nproc --all) installclean
    make -j$(nproc --all) systemimage
    mv $OUT/system.img $BD/system-treble_arm64_bvN.img
    echo
}

generatePackages() {
    echo "--> Generating packages"
    buildDate="$(date +%Y%m%d)"
    xz -cv $BD/system-treble_arm64_bvN.img -T0 > $BD/DerpFest-arm64-ab-14.0-unofficial-$buildDate.img.xz
    rm -rf $BD/system-*.img
    echo
}

START=$(date +%s)

initRepos
syncRepos
applyPatches
setupEnv
buildTrebleApp
buildVariant
generatePackages

END=$(date +%s)
ELAPSEDM=$(($(($END-$START))/60))
ELAPSEDS=$(($(($END-$START))-$ELAPSEDM*60))

echo "--> Buildbot completed in $ELAPSEDM minutes and $ELAPSEDS seconds"
echo
