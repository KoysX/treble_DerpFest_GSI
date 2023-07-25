$(call inherit-product, vendor/derp/config/common_full_phone.mk)
$(call inherit-product, vendor/derp/config/common.mk)
$(call inherit-product, vendor/derp/config/BoardConfigDerpFest.mk)
$(call inherit-product, vendor/derp/config/BoardConfigSoong.mk)
$(call inherit-product, device/derp/sepolicy/common/sepolicy.mk)
-include vendor/derp/build/core/config.mk
                           
TARGET_HAS_FUSEBLK_SEPOLICY_ON_VENDOR := true
TARGET_USES_PREBUILT_VENDOR_SEPOLICY := true
SELINUX_IGNORE_NEVERALLOWS := true

TARGET_NO_KERNEL_OVERRIDE := true
TARGET_NO_KERNEL_IMAGE := true

TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_BOOT_ANIMATION_RES := 1080
USE_LEGACY_BOOTANIMATION := true
EXTRA_UDFPS_ANIMATIONS := true

#PRODUCT_PACKAGES += \
#      OnePlusCameraHelper
