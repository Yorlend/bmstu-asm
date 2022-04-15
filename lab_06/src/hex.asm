%include    'lib/consts.asm'
%include    'lib/iolib.asm'

global hex_convert
extern buf

section .bss
    hex_num     resb    6

section .text

hex_digit:
    cmp dl, 10
    jl return

    add dl, 'A' - 10
    ret

    return:
        add dl, '0'
        ret

hex_convert:
    push eax
    push ecx
    push edx

    mov eax, [buf]
    mov ecx, 4

    iterate:
        dec ecx

        mov dl, 0xF
        and dl, al

        call hex_digit

        mov [hex_num + ecx], dl

        shr ax, 4
        cmp ecx, 0
        jnz iterate
    
    mov byte [hex_num + 4], 0xA
    mov byte [hex_num + 5], 0x0

    mov eax, hex_num
    call sprint
    
    pop edx
    pop ecx
    pop eax

    ret
