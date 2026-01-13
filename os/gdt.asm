; FlyOS - Global Descriptor Table (GDT)
; x86 ASM, NASM syntax

BITS 32

gdt_start:
    ; Null Descriptor (mandatory)
    dd 0x0
    dd 0x0

gdt_kernel_code:
    ; Limit (0-15), Base (0-15)
    dw 0xFFFF
    dw 0x0000
    ; Base (16-23)
    db 0x00
    ; Access byte: P=1, DPL=00, S=1, Type=1010 (Execute/Read)
    db 0x9A
    ; Flags (4 bits), Limit (16-19)
    db 11001111b ; G=1, D=1, L=0, AVL=0
    ; Base (24-31)
    db 0x00

gdt_kernel_data:
    ; Limit (0-15), Base (0-15)
    dw 0xFFFF
    dw 0x0000
    ; Base (16-23)
    db 0x00
    ; Access byte: P=1, DPL=00, S=1, Type=0010 (Read/Write)
    db 0x92
    ; Flags (4 bits), Limit (16-19)
    db 11001111b ; G=1, D=1, L=0, AVL=0
    ; Base (24-31)
    db 0x00

gdt_user_code:
    ; Limit (0-15), Base (0-15)
    dw 0xFFFF
    dw 0x0000
    ; Base (16-23)
    db 0x00
    ; Access byte: P=1, DPL=11, S=1, Type=1010 (Execute/Read)
    db 0xFA
    ; Flags (4 bits), Limit (16-19)
    db 11001111b ; G=1, D=1, L=0, AVL=0
    ; Base (24-31)
    db 0x00

gdt_user_data:
    ; Limit (0-15), Base (0-15)
    dw 0xFFFF
    dw 0x0000
    ; Base (16-23)
    db 0x00
    ; Access byte: P=1, DPL=11, S=1, Type=0010 (Read/Write)
    db 0xF2
    ; Flags (4 bits), Limit (16-19)
    db 11001111b ; G=1, D=1, L=0, AVL=0
    ; Base (24-31)
    db 0x00

gdt_tss:
    ; TSS descriptor (placeholder)
    dd 0x0
    dd 0x0

gdt_end:

; GDT Descriptor (for lgdt instruction)
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; GDT limit
    dd gdt_start                 ; GDT base

; Selectors
KERNEL_CS equ gdt_kernel_code - gdt_start
KERNEL_DS equ gdt_kernel_data - gdt_start
USER_CS   equ gdt_user_code - gdt_start
USER_DS   equ gdt_user_data - gdt_start
TSS_SEL   equ gdt_tss - gdt_start
