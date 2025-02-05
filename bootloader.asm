[BITS 16]
[ORG 0x7C00]

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Load kernel from sector 2
    mov ah, 0x02
    mov al, 1       ; Read 1 sector
    mov ch, 0       ; Cylinder 0
    mov cl, 2       ; Sector 2 (1-based)
    mov dh, 0       ; Head 0
    mov dl, 0       ; Drive 0 (floppy)
    mov bx, 0x1000  ; Load to ES:BX = 0x0000:0x1000
    int 0x13
    jc disk_error

    ; Jump to kernel at physical address 0x1000
    jmp 0x0000:0x1000

disk_error:
    mov si, disk_error_msg
    call print_string
    hlt

print_string:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp print_string
done:
    ret

disk_error_msg db "Disk error!", 0

times 510-($-$$) db 0
dw 0xAA55