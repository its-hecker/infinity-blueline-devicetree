# SPDX-License-Identifier: Apache-2.0
# Pixel 3 development USB ADB defaults for LineageOS/Infinity-X.
# The product controls RSA authorization through WITH_ADB_INSECURE before
# inheriting its ROM common.mk; only userdebug/eng may enable this mode.
PIXEL3_DEV_USB_ADB ?= $(if $(filter userdebug eng,$(TARGET_BUILD_VARIANT)),true,false)

ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),true)
ifeq ($(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
$(error PIXEL3_DEV_USB_ADB=true requires a userdebug or eng build)
endif

# Device defaults alone do not override saved persistent settings on dirty
# flashes, but fresh installs start USB ADB automatically.
# Avoid duplicate persist.sys.usb.config properties across inherited products.
PRODUCT_PRODUCT_PROPERTIES := $(filter-out \
    persist.sys.usb.config=% persist.sys.usb.config?=%, \
    $(PRODUCT_PRODUCT_PROPERTIES))
PRODUCT_PRODUCT_PROPERTIES += persist.sys.usb.config=adb

# Do not bundle host keys or require PIXEL3_ADB_PUBLIC_KEY. In this debug
# configuration the ROM's common.mk handles authorization itself.
else ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),false)
# Keep production USB/ADB defaults unchanged.
else
$(error PIXEL3_DEV_USB_ADB must be true or false)
endif
