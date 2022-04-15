%include    'lib/consts.asm'
%include    'lib/iolib.asm'

extern input_bin, buf, hex_convert, conv_dec

section .data
    inmsg   db 'Input binary signed number:', 0xA, 0
    optmsg  db 'Select menu option:', 0xA,
            db '1. sbin -> uhex', 0xA,
            db '2. sbin -> sdec', 0xA,
            db '0. exit', 0Ah, '> ', 0
    options dd exit, hex_convert, conv_dec

section .bss
    opt     resb 2

section .text
global  _start

_start:
    mov eax, inmsg
    call sprint

    call input_bin

    menu:
        mov eax, optmsg
        call sprint

        mov eax, SYS_READ
        mov ebx, STDIN
        mov ecx, opt
        mov edx, 2
        int 0x80

        xor ebx, ebx
        mov al, [opt]
        sub al, '0'
        mov bl, 4
        mul bl
        mov bl, al

        call options[ebx]
        jmp menu

exit:
    mov     eax, SYS_EXIT
    mov     ebx, 0
    int     80h
 