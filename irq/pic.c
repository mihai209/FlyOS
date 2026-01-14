#include "pic.h"

// Helper inline pentru I/O
static inline void outb(uint16_t port, uint8_t val) {
    asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

// O mică pauză pentru a permite porturilor să se stabilizeze pe hardware mai vechi.
static inline void io_wait(void) {
    outb(0x80, 0);
}

void pic_remap(void) {
    // Salvăm măștile curente
    uint8_t mask1 = inb(PIC1_DATA);
    uint8_t mask2 = inb(PIC2_DATA);

    // ICW1: Începe secvența de inițializare în mod cascadă
    outb(PIC1_COMMAND, 0x11);
    io_wait();
    outb(PIC2_COMMAND, 0x11);
    io_wait();

    // ICW2: Setează offset-urile vectorilor pentru master și slave
    outb(PIC1_DATA, PIC1_VECTOR_OFFSET);
    io_wait();
    outb(PIC2_DATA, PIC2_VECTOR_OFFSET);
    io_wait();

    // ICW3: Spune master-ului că are un slave la IRQ2 (0x04)
    // și slave-ului care este identitatea sa în cascadă (2)
    outb(PIC1_DATA, 4);
    io_wait();
    outb(PIC2_DATA, 2);
    io_wait();

    // ICW4: Mod 8086/88
    outb(PIC1_DATA, 0x01);
    io_wait();
    outb(PIC2_DATA, 0x01);
    io_wait();

    // Restaurăm măștile salvate
    outb(PIC1_DATA, mask1);
    outb(PIC2_DATA, mask2);
}

void pic_send_eoi(uint8_t irq) {
    if (irq >= 8) {
        // Trimite EOI și la slave
        outb(PIC2_COMMAND, PIC_EOI);
    }
    // Trimite EOI la master
    outb(PIC1_COMMAND, PIC_EOI);
}

void pic_set_mask(uint8_t irq, int enable) {
    uint16_t port;
    uint8_t value;

    if (irq < 8) {
        port = PIC1_DATA;
    } else {
        port = PIC2_DATA;
        irq -= 8;
    }

    if (enable) {
        // Demascare: clear bit (set to 0)
        value = inb(port) & ~(1 << irq);
    } else {
        // Mascare: set bit (set to 1)
        value = inb(port) | (1 << irq);
    }
    outb(port, value);
}

void pic_disable(void) {
    // Maschează toate IRQ-urile
    outb(PIC1_DATA, 0xff);
    outb(PIC2_DATA, 0xff);
}