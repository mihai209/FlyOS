#include <stdint.h>
#include "../gdt/gdt.h"
#include "../gdt/tss.h"
#include "../idt/idt.h"

/*
 * Stack-ul kernelului.
 * Pentru început: static, per-BSP.
 * Mai târziu: per-CPU.
 */
__attribute__((aligned(16)))
uint8_t kernel_stack[64 * 1024];

static inline void cpu_halt(void)
{
    for (;;) {
        __asm__ volatile ("hlt");
    }
}

/*
 * Entry point apelat din ASM (de ex. _start).
 * Nu folosim argc/argv, nu folosim ABI de userspace.
 */
void kernel_main(void)
{
    uint64_t stack_top = (uint64_t)kernel_stack + sizeof(kernel_stack);

    /*
     * Ordinea este critică:
     * 1. inițializezi TSS cu stack-ul kernel
     * 2. încarci GDT (care face și LTR)
     */
    tss_init(stack_top);
    gdt_init();
    idt_init();

    /*
     * De aici înainte:
     * – CS/DS/SS sunt valide
     * – TSS este încărcat
     * – IST este pregătit
     *
     * Kernelul este într-o stare deterministă și poate primi întreruperi.
     */

    /* Test pentru a genera o excepție - Division by Zero */
    /* __asm__ volatile ("int $0"); */
    /* __asm__ volatile ("div %bl" :: "a"(1), "b"(0)); */

    cpu_halt();
}
