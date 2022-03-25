public filter_input
extrn buffer: byte

datadop segment word 'data'
    output  db 13, 10
    result  db 5 dup(20h)
            db '$'
datadop ends

codeseg segment para public 'code'
    assume cs:codeseg, es:datadop, ds:seg buffer

filter_input proc near
    mov ax, datadop
    mov es, ax
    
    xor di, di
    xor si, si

    filter:
        mov al, [buffer+si]
        mov [result+di], al
        inc di
        add si, 2
        cmp di, 5
        jne filter

    mov dx, offset output

    mov ax, datadop
    mov ds, ax    

    mov ah, 9

    int 21h
    ret
filter_input endp
codeseg ends
end
