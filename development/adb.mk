# SPDX-License-Identifier: Apache-2.0
# Pixel 3 debug-only ADB setup. Only enabled in userdebug/eng when explicitly
# selected; public builds must not ship unauthenticated USB root.
#
# Infinity-X's common.mk checks WITH_ADB_INSECURE before inheriting it in
# infinity_blueline.mk. This disables ADB authentication while leaving the
# userdebug build debuggable (ro.debuggable=1).
PIXEL3_DEV_USB_ADB ?= $(if $(filter userdebug eng,$(TARGET_BUILD_VARIANT)),true,false)

ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),true)
ifeq ($(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
$(error PIXEL3_DEV_USB_ADB=true requires a userdebug or eng build)
endif

# Explicit ADB USB mode at boot, even without a completed framework boot.
PRODUCT_PRODUCT_PROPERTIES := $(filter-out \
    persist.sys.usb.config=% persist.sys.usb.config?=%, \
    $(PRODUCT_PRODUCT_PROPERTIES))
PRODUCT_PRODUCT_PROPERTIES += persist.sys.usb.config=adb

# Limit early init USB-adbd + automatic root to dedicated debug builds.
# The vendor init RC also checks ro.debuggable=1 and ro.adb.secure=0.
PRODUCT_VENDOR_PROPERTIES += ro.vendor.pixel3.early_adb=1

else ifeq ($(strip $(PIXEL3_DEV_USB_ADB)),false)
# Keep standard secure USB / ADB configuration.
else
$(error PIXEL3_DEV_USB_ADB must be true or false)
endif
