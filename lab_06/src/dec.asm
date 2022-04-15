%include    'lib/consts.asm'
%include    'lib/iolib.asm'

global conv_dec
extern buf

section .bss
    dec_num     resb    8

section .text

conv_dec:
    push eax
    push ebx
    push edx
    push esi

    mov eax, [buf]
    mov bx, 10

    mov esi, 6
    mov byte [dec_num], '+'

    cmp ax, 0
    jge dec_loop

    neg ax
    mov byte [dec_num], '-'

    dec_loop:
        xor dx, dx
        div bx
        add dl, '0'

        dec si
        mov [dec_num + esi], dl
        
        cmp si, 1
        jne dec_loop

    mov byte dec_num[6], 0xA
    mov byte dec_num[7], 0

    mov eax, dec_num
    call sprint

    pop esi
    pop edx
    pop ebx
    pop eax

    ret
