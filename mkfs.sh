dd if=/dev/zero of=uefi.img bs=1M count=64
sudo /usr/sbin/mkfs.vfat uefi.img

export PATH=$PATH:/usr/sbin
mkfs.vfat uefi.img

sudo mount uefi.img /mnt
sudo cp -r uefi/EFI /mnt/
sync
sudo umount /mnt

qemu-system-x86_64 \
  -machine q35 \
  -cpu qemu64 \
  -m 512M \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS.fd \
  -drive format=raw,file=uefi.img \
  -serial stdio \
  -no-reboot
