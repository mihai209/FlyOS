#!/bin/sh

qemu-system-x86_64 \
  -machine q35 \
  -cpu qemu64 \
  -m 512M \
  -nographic \
  -cdrom build/iso/FlyOS.iso \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd \
  -drive if=pflash,format=raw,file=OVMF_VARS.fd \
  -serial stdio \
  -no-reboot
