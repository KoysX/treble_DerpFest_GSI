## Create Directories
As a first step, you'll have to create and enter a folder with the appropriate name.
To do that, run these commands:

```bash
mkdir derp
cd derp
```

## Initalise the Treble DerpFest_GSI repo
```bash
repo init -u https://github.com/DerpFest-AOSP/manifest.git -b 14
```

## Clone this repo:
```bash
git clone https://github.com/KoysX/treble_DerpFest_GSI.git -b 14
```

## Preparing local manifest
```bash
mkdir -p .repo/local_manifests
cp treble_DerpFest_GSI/manifest.xml .repo/local_manifests/dp.xml
```

## Sync the repository
```bash
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
```

### Apply the patches
```bash
bash treble_DerpFest_GSI/apply-patches.sh treble_DerpFest_GSI misc
bash treble_DerpFest_GSI/apply-patches.sh treble_DerpFest_GSI phh
bash treble_DerpFest_GSI/apply-patches.sh treble_DerpFest_GSI ponces
```

## Adapting for DerpFest
copy derp.mk to device/phh/treble in the ROM folder. Then run the following commands:
```bash
 cd device/phh/treble
 bash generate.sh derp
```

### Turn On Caching
You can speed up subsequent builds by adding these lines to your `~/.bashrc` OR `~/.zshrc` file:

```bash
export USE_CCACHE=1
export CCACHE_COMPRESS=1
export CCACHE_MAXSIZE=50G # 50 GB
```

## Compilation 
In the ROM folder, run this to start compilation:

```bash
source build/envsetup.sh

ccache -M 50G -F 0

lunch treble_arm64_bvN-userdebug 

make systemimage -j$(nproc --all)
```

## Compression
After compiling the GSI, you can run this to reduce the `system.img` file size:
> Warning<br>
> You will need to decompress the output file to flash the `system.img`. In other words, you cannot flash this file directly.

```bash
cd out/target/product/tdgsi_arm64_ab
xz -9 -T0 -v -z system.img 
```

## Troubleshooting
If you face any conflicts while applying patches, apply the patch manually.

## Credits
These people have helped this project in some way or another, so they should be the ones who receive all the credit:
- [DerpFest AOSP](https://github.com/DerpFest-AOSP/manifest)
- [Phhusson](https://github.com/phhusson)
- [AndyYan](https://github.com/AndyCGYan)
- [Ponces](https://github.com/ponces)
- [Peter Cai](https://github.com/PeterCxy)
- [Iceows](https://github.com/Iceows)
- [ChonDoit](https://github.com/ChonDoit)
- [Nazim](https://github.com/naz664)
- [UniversalX](https://github.com/orgs/UniversalX-devs/)
- [TQMatvey](https://github.com/TQMatvey)
