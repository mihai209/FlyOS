; FlyOS Stage 1
; Loaded at 0x0000:0x8000
; ASM ONLY

BITS 16
ORG 0x8000

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    sti

    mov si, msg
    call print_string

.hang:
    cli
    hlt
    jmp .hang

print_string:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x0A
    int 0x10
    jmp print_string
.done:
    ret

msg db "Stage1 loaded OK!", 13, 10, 0

; pad EXACTLY 512 bytes
times 512-($-$$) db 0
