; FlyOS MBR
; Step 5: Disk read via INT 13h
; ASM ONLY

BITS 16
ORG 0x7C00

start:
    mov [boot_drive], dl

    cli
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; --- STACK SETUP ---
    mov ss, ax
    mov sp, 0x9000
    sti

    ; --- CLEAR SCREEN ---
    mov ax, 0x0003
    int 0x10

    ; --- PRINT BOOT TEXT ---
    mov si, boot_msg
    call print_string

    ; --- READ STAGE 1 (sector 2) ---
    mov si, load_msg
    call print_string

    call read_sectors
    jc disk_error

    ; --- JUMP TO STAGE 1 ---
    jmp 0x0000:0x8000

disk_error:
    mov si, err_msg
    call print_string
    cli
    hlt
    jmp $

; -------------------------
; reset_disk
; -------------------------
reset_disk:
    mov ah, 0x00
    mov dl, [boot_drive]
    int 0x13
    ret

; -------------------------
; read_sectors
; -------------------------
read_sectors:
    mov di, 3 ; retries

.retry:
    mov ah, 0x02        ; BIOS read sectors
    mov al, 1           ; read 1 sector
    mov ch, 0           ; cylinder 0
    mov cl, 2           ; sector 2 (LBA 1)
    mov dh, 0           ; head 0
    mov dl, [boot_drive]; drive number (BIOS sets it)
    mov bx, 0x8000      ; ES:BX = 0000:8000
    int 0x13
    jnc .done

    call reset_disk
    dec di
    jnz .retry

.done:
    ret

; -------------------------
; print_string
; -------------------------
print_string:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    jmp print_string
.done:
    ret

; -------------------------
; Data
; -------------------------
boot_msg    db "FlyOS MBR OK", 13, 10, 0
load_msg    db "Loading Stage1...", 13, 10, 0
err_msg     db "Disk read error!", 0

boot_drive db 0

times 510-($-$$) db 0
dw 0xAA55
