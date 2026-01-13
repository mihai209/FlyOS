; FlyOS – El Torito 32-bit entry
; Pure protected mode, ELF relocatable
; NASM -f elf32

BITS 32

GLOBAL start
EXTERN kmain

SECTION .text
start:
    cli

    ; Load our own GDT (BIOS one is undefined / garbage)
    lgdt [gdt_descriptor]

    ; Reload segment registers
    mov ax, DATA_SEL
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set up a known-good stack
    mov esp, 0x90000

    ; Call kernel C entry
    call kmain

.halt:
    hlt
    jmp .halt


; =========================
; Global Descriptor Table
; =========================

SECTION .rodata
align 8

gdt:
    dq 0x0000000000000000        ; Null descriptor

    ; Code segment: base=0, limit=4GB, RX
    dq 0x00CF9A000000FFFF

    ; Data segment: base=0, limit=4GB, RW
    dq 0x00CF92000000FFFF

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt - 1
    dd gdt                       ; MUST be 32-bit

; =========================
; Selectors
; =========================

CODE_SEL equ 0x08
DATA_SEL equ 0x10
