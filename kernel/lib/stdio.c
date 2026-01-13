#include "stdio.h"

#define VGA_MEMORY ((volatile unsigned short*)0xB8000)
#define VGA_WIDTH  80
#define VGA_HEIGHT 25
#define VGA_ATTR   0x0F

static unsigned int vga_row = 0;
static unsigned int vga_col = 0;

void vga_clear(void)
{
    volatile unsigned short *vga = VGA_MEMORY;
    for (unsigned int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++)
        vga[i] = (VGA_ATTR << 8) | ' ';

    vga_row = 0;
    vga_col = 0;
}

void vga_putc(char c)
{
    if (c == '\n') {
        vga_col = 0;
        vga_row++;
        return;
    }

    VGA_MEMORY[vga_row * VGA_WIDTH + vga_col] =
        (VGA_ATTR << 8) | (unsigned char)c;

    if (++vga_col >= VGA_WIDTH) {
        vga_col = 0;
        vga_row++;
    }
}

void vga_write(const char *s)
{
    while (*s)
        vga_putc(*s++);
}

void printf(const char *s)
{
    vga_write(s);
}
