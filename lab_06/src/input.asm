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

    not ax
    inc ebx

    bin_loop:

        cmp byte [ebx], '0'
        je increment

        inc ax

        increment:
            shl ax, 1
            inc ebx
            cmp byte [ebx], 0
            jnz bin_loop

    mov [buf], eax

    pop edx
    pop ecx
    pop ebx
    pop eax

    ret