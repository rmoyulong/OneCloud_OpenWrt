# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk

BOARD:=amlogic
BOARDNAME:=Amlogic
BOARDNAME:=Amlogic Meson family
FEATURES:=boot-part ext4 fpu legacy-sdcard squashfs usbgadget
SUBTARGETS:=meson8b

KERNEL_PATCHVER:=6.6

define Target/Description
	Build firmware image for Amlogic Meson SoC devices.
	Currently produces SD Card/USB disk image.
endef

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += \
	e2fsprogs \
	kmod-usb-hid \
	losetup \
	mkf2fs \
	automount \
	parted \
	partx-utils \
	resize2fs

KERNELNAME:=Image dtbs

$(eval $(call BuildTarget))
