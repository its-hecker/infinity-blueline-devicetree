# SPDX-License-Identifier: Apache-2.0
# Project Infinity-X 17 / Google Pixel 3 (blueline)
INFINITY_MAINTAINER := Hecker
WITH_GAPPS ?= false
TARGET_HAS_UDFPS := false
TARGET_FACE_UNLOCK_SUPPORTED := false

# Development-only ADB flag (secure ADB for public builds).
PIXEL3_DEV_USB_ADB ?= $(if $(filter userdebug eng,$(TARGET_BUILD_VARIANT)),true,false)
ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),true)
ifeq ($(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
$(error PIXEL3_DEV_USB_ADB=true requires userdebug or eng)
endif
WITH_ADB_INSECURE := true
# Prevent Infinity-X from disabling ro.debuggable on this diagnostic userdebug.
PRODUCT_NOT_DEBUGGABLE_IN_USERDEBUG := false
else ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),false)
WITH_ADB_INSECURE :=
else
$(error PIXEL3_DEV_USB_ADB must be true or false)
endif

$(call inherit-product, vendor/infinity/config/common_full_phone.mk)
$(call inherit-product, device/google/crosshatch/aosp_blueline.mk)
include device/google/crosshatch/blueline/device-lineage.mk
include device/google/crosshatch/development/adb.mk

PRODUCT_BRAND := google
PRODUCT_MANUFACTURER := Google
PRODUCT_MODEL := Pixel 3
PRODUCT_NAME := infinity_blueline
PRODUCT_DEVICE := blueline

TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="blueline-user 12 SP1A.210812.016.C2 8618562 release-keys" \
    BuildFingerprint=google/blueline/blueline:12/SP1A.210812.016.C2/8618562:user/release-keys \
    DeviceProduct=blueline

# Keep makefile properties as single tokens; PRODUCT_MODEL provides "Pixel 3".
PRODUCT_PRODUCT_PROPERTIES += \
    ro.infinity.soc=SDM845 \
    ro.infinity.camera=12.2MP

$(call inherit-product, vendor/google/blueline/blueline-vendor.mk)
