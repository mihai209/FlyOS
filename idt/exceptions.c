#include "isr.h"
#include "../irq/irq.h" // Pentru a apela dispatcher-ul IRQ
#include "../panic/panic.h"

// Un array de string-uri cu mesajele excepțiilor
const char *exception_messages[] = {
    "Division By Zero", "Debug", "Non Maskable Interrupt", "Breakpoint",
    "Into Detected Overflow", "Out of Bounds", "Invalid Opcode", "No Coprocessor",
    "Double Fault", "Coprocessor Segment Overrun", "Bad TSS", "Segment Not Present",
    "Stack Fault", "General Protection Fault", "Page Fault", "Unknown Interrupt",
    "Coprocessor Fault", "Alignment Check", "Machine Check", "SIMD Floating-Point", 
    "Virtualization", "Control Protection Exception", "Reserved", "Reserved",
    "Reserved", "Reserved", "Reserved", "Reserved", "Reserved", "Reserved",
    "Triple Fault", "Reserved"
};

/*
 * Handler-ul C general pentru toate întreruperile.
 * Este apelat din isr_common_stub.
 */
void isr_handler(registers_t* regs) {
    // Verificăm dacă întreruperea este un IRQ hardware
    if (regs->int_no >= 32 && regs->int_no <= 47) {
        irq_dispatch(regs);
    } else {
        // Este o excepție a procesorului
        if (regs->int_no < 32) {
            kernel_panic(regs, exception_messages[regs->int_no]);
        } else {
            kernel_panic(regs, "Unknown Interrupt");
        }
    }
}