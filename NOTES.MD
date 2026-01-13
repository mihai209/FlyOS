nasm -f bin mbr.asm -o mbr.bin
stat -c %s mbr.bin
qemu-system-i386 -drive format=raw,file=mbr.bin

Result : FlyOS MBR booted
