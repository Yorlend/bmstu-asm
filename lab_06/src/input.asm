%include    'lib/consts.asm'
%include    'lib/iolib.asm'

global input_bin, buf

section .bss
    buf     resb    16

section .text

input_bin:

    push eax
    push ebx
    push ecx
    push edx

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, buf
    mov edx, 16
    int 0x80

    xor eax, eax
    mov ebx, buf

    cmp byte [ebx], '-'
    jne bin_loop

    inc ebx

    bin_loop:
        mov dl, [ebx]
        inc ebx

        cmp dl, 0x0
        je endl

        shl ax, 1

        cmp dl, '0'
        je bin_loop

        inc ax
        jmp bin_loop

    endl:

        dec ax
        shr ax, 1

        cmp byte [buf], '-'
        jne not_neg
        neg ax

    not_neg:

        mov [buf], eax

        pop edx
        pop ecx
        pop ebx
        pop eax

        ret