public buffer
extrn filter_input: near

stkseg segment stack 'stack'
    db 100h dup(?)
stkseg ends

dataseg segment word 'data'
    buffer  db 10 dup(?)
dataseg ends

codeseg segment para public 'code'
    assume ds:dataseg, cs:codeseg

main:
    mov ax, dataseg
    mov ds, ax

    mov cx, 10
    mov ah, 1

    xor bx, bx
    input:
        int 21h
        mov [buffer+bx], al
        inc bx
        loop input
    
    call filter_input

    mov ax, 4C00h
    int 21h

codeseg ends
    end main
