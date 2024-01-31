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
        repo init -u https://github.com/DerpFest-AOSP/manifest.git -b 14 --depth=1
        echo

        echo "--> Preparing local manifest"
        mkdir -p .repo/local_manifests
        cp $BL/manifest.xml .repo/local_manifests/aosp.xml
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

buildGappsVariant() {
    echo "--> Building treble_arm64_bgN"
    lunch treble_arm64_bgN-userdebug
    make -j$(nproc --all) installclean
    make -j$(nproc --all) systemimage
    mv $OUT/system.img $BD/system-treble_arm64_bgN.img
    echo
}

buildMiniVariant() {
    echo "--> Building treble_arm64_bgN-mini"
    lunch treble_arm64_bgN_mini-userdebug
    make -j$(nproc --all) installclean
    make -j$(nproc --all) systemimage
    mv $OUT/system.img $BD/system-treble_arm64_bgN-mini.img
    echo
}

buildPicoVariant() {
    echo "--> Building treble_arm64_bgN-pico"
    lunch treble_arm64_bgN_pico-userdebug
    make -j$(nproc --all) installclean
    make -j$(nproc --all) systemimage
    mv $OUT/system.img $BD/system-treble_arm64_bgN-pico.img
    echo
}

generatePackages() {
    echo "--> Generating packages"
    buildDate="$(date +%Y%m%d)"
    xz -cv $BD/system-treble_arm64_bgN.img -T0 > $BD/DerpFest-arm64_bgN-14.0-unofficial-$buildDate.img.xz
    xz -cv $BD/system-treble_arm64_bgN-mini.img -T0 > $BD/DerpFest-arm64_bgN-mini-14.0-unofficial-$buildDate.img.xz
    xz -cv $BD/system-treble_arm64_bgN-pico.img -T0 > $BD/DerpFest-arm64_bgN-pico-14.0-unofficial-$buildDate.img.xz
    rm -rf $BD/system-*.img
    echo
}

generateOta() {
    echo "--> Generating OTA file"
    version="$(date +v%Y.%m.%d)"
    timestamp="$START"
    json="{\"version\": \"$version\",\"date\": \"$timestamp\",\"variants\": ["
    find $BD/ -name "DerpFest-*" | sort | {
        while read file; do
            filename="$(basename $file)"
            if [[ $filename == *"mini"* ]]; then
                name="treble_arm64_bgN-mini"
            elif [[ $filename == *"pico"* ]]; then
                name="treble_arm64_bgN-pico"
            else
                name="treble_arm64_bgN"
            fi
            size=$(wc -c $file | awk '{print $1}')
            url="https://github.com/KoysX/treble_DerpFest_GSI/releases/download/$version/$filename"
            json="${json} {\"name\": \"$name\",\"size\": \"$size\",\"url\": \"$url\"},"
        done
        json="${json%?}]}"
        echo "$json" | jq . > $BL/ota.json
    }
    echo
}

START=$(date +%s)

initRepos
syncRepos
applyPatches
setupEnv
buildTrebleApp
buildGappsVariant
buildMiniVariant
buildPicoVariant
generatePackages
generateOta

END=$(date +%s)
ELAPSEDM=$(($(($END-$START))/60))
ELAPSEDS=$(($(($END-$START))-$ELAPSEDM*60))

echo "--> Buildbot completed in $ELAPSEDM minutes and $ELAPSEDS seconds"
echo
