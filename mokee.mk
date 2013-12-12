$(call inherit-product, device/samsung/i9500/full_i9500.mk)

# Inherit some common MoKee stuff
$(call inherit-product, vendor/mk/config/gsm.mk)

# Enhanced NFC
$(call inherit-product, vendor/mk/config/nfc_enhanced.mk)

# Inherit some common MoKee stuff.
$(call inherit-product, vendor/mk/config/common_full_phone.mk)

PRODUCT_NAME := mk_i9500
PRODUCT_DEVICE := i9500

PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=ja3gxx TARGET_DEVICE=ja3g BUILD_FINGERPRINT="samsung/ja3gxx/ja3g:4.2.2/JDQ39/I9500XXUAMDK:user/release-keys" PRIVATE_BUILD_DESC="ja3gxx-user 4.2.2 JDQ39 I9500XXUAMDK release-keys"
