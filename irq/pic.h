#ifndef PIC_H
#define PIC_H

#include <stdint.h>

// Porturile I/O pentru PIC 8259
#define PIC1_COMMAND 0x20
#define PIC1_DATA    0x21
#define PIC2_COMMAND 0xA0
#define PIC2_DATA    0xA1

// Comanda End-of-Interrupt (EOI)
#define PIC_EOI 0x20

// Vectorii de bază pentru IRQ-uri după remapare
#define PIC1_VECTOR_OFFSET 0x20 // IRQ 0-7  -> vectori 32-39
#define PIC2_VECTOR_OFFSET 0x28 // IRQ 8-15 -> vectori 40-47

/**
 * @brief Remapează controlerele PIC pentru a evita conflictele cu excepțiile CPU.
 * IRQ 0-7 vor fi mapate la vectorii 32-39.
 * IRQ 8-15 vor fi mapate la vectorii 40-47.
 */
void pic_remap(void);

/**
 * @brief Trimite comanda End-of-Interrupt (EOI) la PIC.
 * Trebuie apelat la finalul fiecărui handler de IRQ.
 * @param irq Numărul IRQ-ului (0-15).
 */
void pic_send_eoi(uint8_t irq);

/**
 * @brief Setează masca de întreruperi pentru PIC.
 * Un bit setat la 1 în mască dezactivează (maschează) IRQ-ul corespunzător.
 * @param irq Numărul IRQ-ului (0-15) de mascat/demascat.
 * @param enable 1 pentru a demasca (enable), 0 pentru a masca (disable).
 */
void pic_set_mask(uint8_t irq, int enable);

/**
 * @brief Dezactivează complet ambele controlere PIC.
 */
void pic_disable(void);

#endif // PIC_H