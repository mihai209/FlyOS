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

    call enable_a20
    call check_a20

    mov si, a20_msg
    call print_string

    mov si, msg
    call print_string

.hang:
    cli
    hlt
    jmp .hang

; -------------------------
; Enable A20 (Fast Gate)
; -------------------------
enable_a20:
    in al, 0x92
    or al, 00000010b    ; set A20 bit
    and al, 11111110b   ; keep reset bit clear
    out 0x92, al
    ret

; -------------------------
; Check A20
; -------------------------
check_a20:
    push ds
    push es

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, 0x0000
    mov di, 0x0010

    mov al, [ds:si]
    mov bl, [es:di]

    mov byte [ds:si], 0x00
    mov byte [es:di], 0xFF

    cmp byte [ds:si], 0xFF

    mov byte [ds:si], al
    mov byte [es:di], bl

    pop es
    pop ds
    ret

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

a20_msg db "A20 enabled", 13, 10, 0
msg db "Stage1 loaded OK!", 13, 10, 0

; pad EXACTLY 512 bytes
times 512-($-$$) db 0
