#include <stdint.h>

__attribute__((section(".multiboot")))
__attribute__((used))
const uint32_t multiboot2_header[] = {
    0xe85250d6,        // magic
    0,                 // architecture (i386)
    24,                // header length
    0x17adaf12         // checksum = -(magic + arch + length)
};
