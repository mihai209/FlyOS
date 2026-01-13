# FlyOS MBR

This directory contains the source code for the FlyOS Master Boot Record.

## Compiling

To compile the MBR, you need to have `nasm` installed. You can then run the following command in this directory:

```bash
nasm -f bin mbr.asm -o mbr.bin
```

Alternatively, you can use the provided Makefile:

```bash
make
```

## Running

To run the MBR in an emulator, you can use the following command:

```bash
qemu-system-i386 -drive format=raw,file=mbr.bin
```

Or, using the Makefile:

```bash
make run
```
