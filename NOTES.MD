nasm -f bin mbr.asm -o mbr.bin
stat -c %s mbr.bin
qemu-system-i386 -drive format=raw,file=mbr.bin

Result : FlyOS MBR booted

nasm -f bin stage1.asm -o stage1.bin
cat mbr.bin stage1.bin > flyos.img
stat -c %s flyos.img
qemu-system-i386 -drive format=raw,file=flyos.img

Result : 
FlyOS MBR OK
Loading Stage1...
Stage1 loaded OK!
