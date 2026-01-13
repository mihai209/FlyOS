#ifndef FLYOS_STDIO_H
#define FLYOS_STDIO_H

#include "types.h"

/* VGA text mode API */
void vga_clear(void);
void vga_putc(char c);
void vga_write(const char *s);
void printf(const char *s);

#endif
