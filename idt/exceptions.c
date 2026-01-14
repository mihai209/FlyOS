#include "isr.h"
 
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
    // Aici poți adăuga cod pentru a afișa pe ecran, de exemplu.
    // Momentan, vom simula o panică.
    if (regs->int_no < 32) {
        // Afișează mesajul de excepție (necesită o funcție de printare)
        // printk("Received interrupt: %d - %s\n", regs.int_no, exception_messages[regs.int_no]);
        // printk("Error code: %x\n", regs.err_code);
    }
 
    // Oprește sistemul
    for (;;) {
        asm volatile("cli; hlt");
    }
}