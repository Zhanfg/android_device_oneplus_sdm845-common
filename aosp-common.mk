# AOSP-facing wrapper around the known-good SDM845 hardware description.
#
# common.mk remains the hardware donor while Android 17 bring-up is in progress.
# This wrapper explicitly prevents Lineage-specific runtime components and
# overlays from entering the product image. Each omitted feature will be
# reintroduced later using ROM-owned/AOSP-facing implementations.

$(call inherit-product, device/oneplus/sdm845-common/common.mk)

# Do not overlay Lineage SDK / Lineage application resources into AOSP.
DEVICE_PACKAGE_OVERLAYS := $(filter-out \
    device/oneplus/sdm845-common/overlay-lineage, \
    $(DEVICE_PACKAGE_OVERLAYS))

# Runtime components whose implementation or Java package/API is tied to
# LineageOS. Keep their low-level hardware knowledge as donor code only.
PRODUCT_PACKAGES := $(filter-out \
    vendor.lineage.health-service.default \
    vendor.lineage.livedisplay-service.oneplus \
    vendor.lineage.livedisplay-service.oneplus_sdm845 \
    vendor.lineage.touch-service.oneplus \
    OnePlusDoze \
    OnePlusDiracGef \
    KeyHandler, \
    $(PRODUCT_PACKAGES))

# The old Lineage-specific Soong configuration values in common.mk are inert
# once the corresponding services are excluded. They remain temporarily only
# to keep common.mk close to its known-good hardware reference until those
# subsystems are replaced.
