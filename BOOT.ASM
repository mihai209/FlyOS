BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov bx, 0x8000        ; load address
    mov dh, 4             ; sectors
    call load_stage2

    jmp 0x0000:0x8000     ; jump to C bootloader

load_stage2:
    pusha
    mov ah, 0x02
    mov al, dh
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x80
    int 0x13
    jc $
    popa
    ret

times 510-($-$$) db 0
dw 0xAA55
