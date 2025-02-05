[BITS 16]
[ORG 0x1000]  ; Matches physical address 0x1000

kernel_start:
    mov si, hello_msg
    call print_string
    hlt
    jmp $

print_string:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp print_string
done:
    ret

hello_msg db "Hello, World!", 0

times 512-($-$$) db 0  ; Pad to 1 sector