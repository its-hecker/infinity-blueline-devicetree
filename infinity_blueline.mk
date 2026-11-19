# Pixel 3 Infinity-X product built from untouched LineageOS 24.0 hardware files
INFINITY_MAINTAINER := Hecker
WITH_GAPPS ?= true
PRODUCT_MODULE_BUILD_FROM_SOURCE := true
TARGET_HAS_UDFPS := false
TARGET_FACE_UNLOCK_SUPPORTED := false

#
# Copyright (C) 2018-2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Infinity-X Android 17 for Pixel 3 (LineageOS 24.0 hardware baseline).

# Developer-only first-boot diagnostics: make wired ADB available without a
# per-computer RSA prompt on userdebug/eng. Any physically connected USB host
# may access ADB on these builds; do not ship this setting in release builds.
PIXEL3_DEV_USB_ADB ?= $(if $(filter userdebug eng,$(TARGET_BUILD_VARIANT)),true,false)
ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),true)
ifeq ($(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
$(error PIXEL3_DEV_USB_ADB=true requires a userdebug or eng build)
endif
# Infinity-X vendor/infinity/config/common.mk sets ro.adb.secure=0 when set.
WITH_ADB_INSECURE := true
else ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),false)
WITH_ADB_INSECURE :=
else
$(error PIXEL3_DEV_USB_ADB must be true or false)
endif

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/infinity/config/common_full_phone.mk)

# Infinity-X defaults userdebug to ro.debuggable=0 unless explicitly restored.
# Do this *after* inheriting common_full_phone.mk to prevent that override.
ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),true)
PRODUCT_NOT_DEBUGGABLE_IN_USERDEBUG := false
endif

# Inherit device configuration
$(call inherit-product, device/google/crosshatch/aosp_blueline.mk)

include device/google/crosshatch/blueline/device-lineage.mk

# Device identifier. This must come after all inclusions
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 3
PRODUCT_NAME := infinity_blueline

# Boot animation
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="blueline-user 12 SP1A.210812.016.C2 8618562 release-keys" \
    BuildFingerprint=google/blueline/blueline:12/SP1A.210812.016.C2/8618562:user/release-keys \
    DeviceProduct=blueline

$(call inherit-product, vendor/google/blueline/blueline-vendor.mk)

# Development USB debugging defaults for the Pixel 3 port.
include device/google/crosshatch/development/adb.mk
