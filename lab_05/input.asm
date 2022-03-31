public input_matrix
extrn rows: byte, cols: byte, matrix: byte

datamsg segment word 'data'
    msg_rows    db "Input rows: $"
    msg_cols    db 13, 10, "Input cols: $"
    msg_matrix  db 13, 10, "Input matrix: $"
datamsg ends

codeseg segment para public 'code'
    assume ds:datamsg, es:seg matrix, cs:codeseg

input_matrix proc near
    mov ax, datamsg
    mov ds, ax

    mov ah, 9h
    mov dx, offset msg_rows
    int 21h

    mov dx, offset msg_cols
    int 21h

    ret
input_matrix endp
codeseg ends
    end