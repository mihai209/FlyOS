#!/bin/sh
set -e

OVMF_CODE=/usr/share/OVMF/OVMF_CODE_4M.fd
OVMF_VARS=OVMF_VARS.fd

FAT_IMG=build/flyos-fat.img
FAT_SIZE_MB=64

MEMORY=512M
CPU=qemu64

# Creează imagine FAT dacă nu există
if [ ! -f "$FAT_IMG" ]; then
  echo "[+] Creating FAT image"
  mkdir -p build
  dd if=/dev/zero of="$FAT_IMG" bs=1M count=$FAT_SIZE_MB
  sudo /usr/sbin/mkfs.vfat "$FAT_IMG"
fi

# Copiază BOOTX64.EFI în imagine
echo "[+] Updating EFI partition"
sudo mkdir -p /mnt/flyos-fat
sudo mount "$FAT_IMG" /mnt/flyos-fat
sudo mkdir -p /mnt/flyos-fat/EFI/BOOT
sudo cp iso/EFI/BOOT/BOOTX64.EFI /mnt/flyos-fat/EFI/BOOT/
sync
sudo umount /mnt/flyos-fat

echo "[+] Booting FlyOS (UEFI, FAT disk)"

qemu-system-x86_64 \
  -machine q35 \
  -cpu "$CPU" \
  -m "$MEMORY" \
  -nographic \
  -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
  -drive if=pflash,format=raw,file="$OVMF_VARS" \
  -drive format=raw,file="$FAT_IMG" \
  -serial stdio \
  -no-reboot
