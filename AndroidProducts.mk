# Project Infinity-X 17 / Google Pixel 3 (blueline)
# Limit product discovery to the supported Infinity-X target.
# The imported LineageOS and AOSP definitions require other ROM product
# configs and must not be exposed as valid Infinity-X lunch choices.

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/infinity_blueline.mk

COMMON_LUNCH_CHOICES := \
    infinity_blueline-cp2a-userdebug
