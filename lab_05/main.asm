public rows, cols, matrix
extrn input_matrix: near

stkseg segment stack 'stack'
    db 100h dup(0)
stkseg ends

dataseg segment word 'data'
    rows    db ?
    cols    db ?
    matrix  db 81 dup(0)
dataseg ends

codeseg segment para public 'code'
    assume ds:dataseg, cs:codeseg

main:
    mov ax, dataseg
    mov ds, ax

    call input_matrix

    mov ah, 4Ch
    int 21h
codeseg ends
    end main
