#include "stdio.h"
#include "types.h"

static volatile uint16_t* vga = (uint16_t*)0xB8000;
static uint16_t pos = 0;

void putc(char c) {
    if (c == '\n') {
        pos += 80 - (pos % 80);
        return;
    }
    vga[pos++] = (0x07 << 8) | c;
}

void printf(const char* s) {
    while (*s) putc(*s++);
}
