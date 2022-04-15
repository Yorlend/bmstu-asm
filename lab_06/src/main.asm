%include    'lib/consts.asm'
%include    'lib/iolib.asm'

extern input_bin, buf

section .data
    inmsg     db      'Input binary signed number:', 0Ah, 0h

section .text
global  _start

_start:

    mov eax, inmsg
    call sprint

    call input_bin

    mov eax, [buf]
    call iprintLF

    mov     ebx, 0
    mov     eax, SYS_EXIT
    int     80h
 