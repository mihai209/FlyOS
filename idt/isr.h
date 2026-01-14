#ifndef ISR_H
#define ISR_H
 
#include <stdint.h>
 
// Structura care conține starea registrelor salvate pe stivă de către stub-ul ISR.
// Ordinea este importantă și corespunde instrucțiunilor PUSH din isr_stubs.S
typedef struct {
    uint64_t r15, r14, r13, r12, r11, r10, r9, r8;
    uint64_t rdi, rsi, rbp, rdx, rcx, rbx, rax;
    uint64_t int_no;        // Numărul întreruperii
    uint64_t err_code;      // Codul de eroare (sau 0 dacă nu este împins de CPU)
    uint64_t rip;           // Instruction Pointer
    uint64_t cs;            // Code Segment
    uint64_t rflags;        // RFLAGS register
    uint64_t rsp;           // Stack Pointer
    uint64_t ss;            // Stack Segment
} __attribute__((packed)) registers_t;
 
// Handler-ul C general pentru toate întreruperile
void isr_handler(registers_t* regs);

#endif // ISR_H