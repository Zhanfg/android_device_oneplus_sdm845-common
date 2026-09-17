# SDM845 common AOSP 17 bring-up

This branch is a hardware compatibility bridge for the OnePlus 6 AOSP 17 port.
The final ROM is AOSP-based; this tree must not make LineageOS a framework or runtime dependency.

## Current structure

`common.mk` is preserved close to the known-good hardware implementation.
`aosp-common.mk` is the shipping-facing wrapper and filters runtime components tied to Lineage APIs/namespaces.

Currently excluded from the product image:

- `vendor.lineage.health-service.default`
- `vendor.lineage.livedisplay-service.oneplus*`
- `vendor.lineage.touch-service.oneplus`
- `OnePlusDoze`
- `OnePlusDiracGef`
- `KeyHandler`
- all `overlay-lineage` overlays

Lineage-only `Android.bp` files for LiveDisplay and PocketMode have been detached from the Soong graph. Their source remains temporarily as donor material.

## Security / VINTF policy

- No Lineage device framework matrix.
- AVB is enabled; do not disable verification or hashtrees in the normal product configuration.
- Legacy Qualcomm/OOS HAL contracts may remain while proprietary userspace is required, but new device-owned interfaces should move toward stable AIDL where practical.
- SELinux must remain enforcing for release targets.

## Replacement order

1. get AOSP product/Soong parsing clean
2. preserve existing audio/camera/modem vendor compatibility
3. replace Lineage-specific device services with ROM-owned/AOSP-facing equivalents
4. migrate graphics/userspace and Qualcomm bridge components where safe
5. migrate kernel to GKI 5.15 + `vendor_dlkm`/`system_dlkm`
6. move root integration to signed ReSukiSU LKM delivery

Do not re-enable a donor module solely to fix a missing symbol. Port the required hardware behavior behind an AOSP/ROM-owned interface instead.
