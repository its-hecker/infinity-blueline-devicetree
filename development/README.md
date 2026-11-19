# Pixel 3 USB ADB diagnostics (LineageOS 24 / Infinity-X 17)

The Pixel 3 blueline development products can enable USB ADB without needing a
PC public key or accepting an on-screen RSA authorization popup. This is only
for **userdebug** and **eng** builds. It intentionally weakens USB security:
**any PC with physical USB access to the booted device can use ADB**.

Development defaults when `PIXEL3_DEV_USB_ADB=true`:
- `ro.adb.secure=0` from the ROM-specific common.mk (`WITH_ADB_INSECURE=true`).
- `persist.sys.usb.config=adb` as an image default for a fresh install.
- No `PRODUCT_ADB_KEYS`, `PIXEL3_ADB_PUBLIC_KEY`, or host key copying required.

The default Infinity-X build helper uses `userdebug` and
`PIXEL3_DEV_USB_ADB=true`. It must **never** be used for a public release.
`user` builds cannot enable the development flag.

To retain normal ADB authorization on a development build:

```bash
PIXEL3_DEV_USB_ADB=false bash .repo/local_manifests/build.sh
```

USB settings from a previous ROM can remain in `/data` after a dirty flash,
overriding image defaults. A disabled USB debugging state may require manually
enabling it (if Android can boot) or testing with a clean diagnostic install.

Verification on the device once Android init, adbd and USB are running:

```bash
adb devices
adb shell getprop ro.adb.secure
adb shell getprop ro.debuggable
adb shell getprop persist.sys.usb.config
adb logcat -b all -v threadtime > blueline-infinity-boot.log
```

For a fresh diagnostic build, expect `device` in `adb devices`,
`ro.adb.secure=0`, `ro.debuggable=1` and a USB config containing `adb`.
These defaults do not enable wireless ADB, ADB root or permissive SELinux.
Kernel panics and early-boot failures can occur before adbd is available.

Disable `PIXEL3_DEV_USB_ADB` and verify secure authentication before
publishing a ROM for other users.
