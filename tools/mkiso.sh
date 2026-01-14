#!/bin/sh
set -e

ISO_DIR=iso
OUT_DIR=build/iso
ISO_NAME=FlyOS.iso

mkdir -p "$OUT_DIR"

xorriso -as mkisofs \
  -R -J \
  -efi-boot EFI/BOOT/BOOTX64.EFI \
  -efi-boot-part \
  -no-emul-boot \
  -o "$OUT_DIR/$ISO_NAME" \
  "$ISO_DIR"

echo "ISO built: $OUT_DIR/$ISO_NAME"
