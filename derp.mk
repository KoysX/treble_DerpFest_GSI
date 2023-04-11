$(call inherit-product, vendor/derp/config/common.mk)
$(call inherit-product, vendor/derp/config/BoardConfigSoong.mk)
$(call inherit-product, vendor/derp/config/BoardConfigDerpFest.mk)
$(call inherit-product, device/derp/sepolicy/common/sepolicy.mk)
-include vendor/derp/build/core/config.mk

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
# Inherit some common derp stuff
$(call inherit-product, vendor/derp/config/common_full_phone.mk)

TARGET_NO_KERNEL_OVERRIDE := true
TARGET_NO_KERNEL_IMAGE := true
SELINUX_IGNORE_NEVERALLOWS := true
TARGET_BOOT_ANIMATION_RES := 1080

TARGET_USES_PREBUILT_VENDOR_SEPOLICY := true
TARGET_HAS_FUSEBLK_SEPOLICY_ON_VENDOR := true

TARGET_FACE_UNLOCK_SUPPORTED := true


# Use CCache
USE_CCACHE := true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
	persist.sys.binary_xml=false \
	dalvik.vm.dex2oat64.enabled=true \

# Google Camera Lite
PRODUCT_PACKAGES += \
       GoogleCameraGo


# Set Bootanimation at 720P
TARGET_BOOT_ANIMATION_RES := 720

# APN
PRODUCT_PACKAGES += apns-conf.xml
