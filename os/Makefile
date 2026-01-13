# FlyOS - MBR Makefile
# ASM ONLY

ASM     = nasm
ASMFLAGS= -f bin

TARGET  = mbr.bin
SRC     = mbr.asm

.PHONY: all run clean size

all: $(TARGET)

$(TARGET): $(SRC)
	$(ASM) $(ASMFLAGS) $(SRC) -o $(TARGET)

run: $(TARGET)
	qemu-system-i386 -drive format=raw,file=$(TARGET)

size: $(TARGET)
	@echo "MBR size:"
	@stat -c %s $(TARGET)

clean:
	rm -f $(TARGET)
