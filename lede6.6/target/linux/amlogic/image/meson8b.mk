# SPDX-License-Identifier: GPL-2.0-only

define Device/Default
  PROFILES = Default $$(DEVICE_NAME)
  KERNEL_NAME := Image
  KERNEL_DEPENDS = $$(wildcard $(DTS_DIR)/$$(DEVICE_DTS).dts)
  KERNEL := kernel-bin | uImage-meson none
  FILESYSTEMS := ext4
  IMAGES := sdcard.img
endef

define Device/thunder-onecloud
  DEVICE_DTS := amlogic/meson8b-onecloud
  DEVICE_TITLE := Thunder OneCloud
  KERNEL_LOADADDR := 0x00208000
  IMAGE/sdcard.img := sdcard-img $$(DEVICE_NAME)
endef
TARGET_DEVICES += thunder-onecloud
