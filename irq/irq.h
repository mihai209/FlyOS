#ifndef IRQ_H
#define IRQ_H

#include <stdint.h>
#include "../idt/isr.h"

// Semnătura unui handler de IRQ
typedef void (*irq_handler_t)(registers_t* regs);

/**
 * @brief Inițializează subsistemul IRQ.
 * Remapează PIC-ul și maschează toate întreruperile.
 */
void irq_init(void);

/**
 * @brief Înregistrează un handler pentru un anumit IRQ.
 * @param irq Numărul IRQ-ului (0-15).
 * @param handler Pointer la funcția handler.
 */
void irq_register_handler(uint8_t irq, irq_handler_t handler);

/**
 * @brief Șterge un handler pentru un anumit IRQ.
 * @param irq Numărul IRQ-ului (0-15).
 */
void irq_unregister_handler(uint8_t irq);

/**
 * @brief Funcția de dispatch apelată de stub-ul de întrerupere.
 * Determină ce handler să apeleze și trimite EOI.
 * @param regs Starea registrelor salvată de stub.
 */
void irq_dispatch(registers_t* regs);


#endif // IRQ_H