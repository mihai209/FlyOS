; ==========================================================
; LOADER.ASM — FlyOS protected mode loader (HDD)
; ==========================================================

BITS 16
ORG 0x1000

start:
    cli
    lgdt [gdt_desc]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEL:pm_start


; ================= GDT =================

gdt_start:
    dq 0
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:

gdt_desc:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEL equ 0x08
DATA_SEL equ 0x10


; ================= PROTECTED MODE =================

[BITS 32]
pm_start:
    cli

    mov ax, DATA_SEL
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9F000

    lidt [idt_desc]

    mov edi, 0xB8000
    mov ecx, 80*25
    mov ax, 0x0720
    rep stosw

    mov esi, msg
    call print

halt:
    hlt
    jmp halt


print:
    mov edi, 0xB8000
.next:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0F
    stosw
    jmp .next
.done:
    ret

msg db "FlyOS in protected mode (HDD)", 0


; ================= ISR =================

isr_stub:
    pusha
    mov byte [0xB8000], '!'
    mov byte [0xB8001], 0x0C
    popa
    iret


; ================= IDT =================

align 8
idt_start:
%rep 256
    dw (abs isr_stub) & 0xFFFF
    dw CODE_SEL
    db 0
    db 0x8E
    dw ((abs isr_stub) >> 16) & 0xFFFF
%endrep
idt_end:

idt_desc:
    dw idt_end - idt_start - 1
    dd idt_start
