; FlyOS MBR
; Step 2: Proper stack setup
; ASM ONLY

BITS 16
ORG 0x7C00

start:
    cli

    xor ax, ax
    mov ds, ax
    mov es, ax

    ; --- STACK SETUP ---
    mov ss, ax
    mov sp, 0x9000     ; safe stack (below EBDA, above MBR)

    sti

    ; Clear screen
    mov ax, 0x0003
    int 0x10

    ; Print message
    mov si, boot_msg
.print:
    lodsb
    test al, al
    jz .hang
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    jmp .print

.hang:
    cli
    hlt
    jmp .hang

boot_msg db "FlyOS MBR stack OK", 0

times 510-($-$$) db 0
dw 0xAA55
