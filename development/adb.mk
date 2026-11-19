# SPDX-License-Identifier: Apache-2.0
# Pixel 3 bring-up: default USB ADB for userdebug/eng, but keep RSA authorization.
# For prompt-free access to ONE trusted development computer, build.sh can
# place that computer's public ADB key in out/hecker-adb/blueline.pub.
PIXEL3_DEV_USB_ADB ?= $(if $(filter userdebug eng,$(TARGET_BUILD_VARIANT)),true,false)

ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),true)
ifeq ($(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
$(error PIXEL3_DEV_USB_ADB=true requires a userdebug or eng build)
endif

# Avoid duplicate persist.sys.usb.config build properties.
PRODUCT_PRODUCT_PROPERTIES := $(filter-out \
    persist.sys.usb.config=% persist.sys.usb.config?=%, \
    $(PRODUCT_PRODUCT_PROPERTIES))
PRODUCT_PRODUCT_PROPERTIES += persist.sys.usb.config=adb

ifeq ($(strip $(PIXEL3_ADB_HOST_KEY)),true)
ifeq ($(wildcard out/hecker-adb/blueline.pub),)
$(error Missing out/hecker-adb/blueline.pub: set PIXEL3_ADB_PUBLIC_KEY to your adbkey.pub before building)
endif
PRODUCT_ADB_KEYS += out/hecker-adb/blueline.pub
else ifeq ($(strip $(PIXEL3_ADB_HOST_KEY)),false)
# Secure ADB is still on, but the normal on-screen authorization is required.
else
$(error PIXEL3_ADB_HOST_KEY must be true or false)
endif
else ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),false)
# Leave secure production defaults unchanged.
else
$(error PIXEL3_DEV_USB_ADB must be true or false)
endif
