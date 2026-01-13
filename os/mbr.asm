; FlyOS MBR
; Runs at 0x7C00
; ASM ONLY

BITS 16
ORG 0x7C00

start:
    cli                 ; disable interrupts
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; simple stack
    sti

    ; Clear screen (text mode)
    mov ax, 0x0003
    int 0x10

    ; Print message
    mov si, boot_msg
.print:
    lodsb
    or al, al
    jz .hang
    mov ah, 0x0E        ; teletype output
    mov bh, 0x00
    mov bl, 0x07        ; light gray
    int 0x10
    jmp .print

.hang:
    cli
    hlt
    jmp .hang

boot_msg db "FlyOS MBR booted", 0

; Pad to 510 bytes
times 510-($-$$) db 0

; Boot signature
dw 0xAA55
