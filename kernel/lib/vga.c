#include "vga.h"

static uint16_t* const VGA = (uint16_t*)0xB8000;
static uint8_t x = 0, y = 0;

static uint16_t entry(char c) {
    return (uint16_t)c | 0x0F00;
}

void vga_clear(void) {
    for (int i = 0; i < 80 * 25; i++)
        VGA[i] = entry(' ');
    x = y = 0;
}

void vga_puts(const char* s) {
    while (*s) {
        if (*s == '\n') {
            x = 0;
            y++;
        } else {
            VGA[y * 80 + x] = entry(*s);
            x++;
        }
        if (x >= 80) {
            x = 0;
            y++;
        }
        if (y >= 25)
            y = 0;
        s++;
    }
}
