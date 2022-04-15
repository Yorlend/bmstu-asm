public rows, cols, matrix

stkseg segment stack 'stack'
    db 100h dup(0)
stkseg ends

datas segment word 'data'
    rows        db ?
    cols        db ?
    matrix      db 81 dup(0)
    result      db 81 dup(0)
    msg_rows    db "Input rows: $"
    msg_cols    db 13, 10, "Input cols: $"
    msg_matrix  db 13, 10, "Input matrix: $"
    msg_result  db 13, 10, "Result:", 13, 10, "$"
    newline     db 13, 10, "$"
datas ends

codes segment para public 'code'
    assume ds:datas, cs:codes

main:
    mov ax, datas
    mov ds, ax

    ; =================================
    ; READING ROWS NUMBER
    ; =================================

    mov ah, 9h
    mov dx, offset msg_rows
    int 21h

    mov ah, 1h
    
    int 21h
    sub al, '0'

    mov rows, al

    ; =================================
    ; READING COLS NUMBER
    ; =================================

    mov ah, 9h
    mov dx, offset msg_cols
    int 21h

    mov ah, 1h

    int 21h
    sub al, '0'

    mov cols, al

    ; =================================
    ; MATRIX INPUT
    ; =================================

    xor bh, bh
    xor di, di

    mov cx, 9
    sub cl, cols
    mov dx, offset newline
    mov ah, 9h
    int 21h

    row_input:
        mov ah, 1h
        xor bl, bl
        col_input:
            int 21h
            
            mov matrix[di], al
            inc di
            inc bl
            cmp bl, cols
            jne col_input
        mov ah, 9h
        int 21h

        inc bh
        add di, cx
        cmp bh, rows
        jne row_input

    ; =================================
    ; MATRIX ROTATION >o<
    ; =================================

    call calc_position

    xor bh, bh
    xor si, si

    row_rotate:
        mov ah, 1h
        xor bl, bl
        col_rotate:
            mov al, matrix[si]
            mov result[di], al

            inc si
            inc bl
            sub di, 9
            cmp bl, cols
            jne col_rotate
        inc bh
        add si, cx
        mov ax, di
        call calc_position
        add di, ax
        add di, 9
        inc di
        cmp bh, rows
        jne row_rotate

    ; =================================
    ; MATRIX OUTPUT
    ; =================================

    xor bh, bh
    xor di, di

    mov cx, 9
    sub cl, rows

    mov dx, offset msg_result
    mov ah, 9h
    int 21h

    row_output:
        mov ah, 2h
        xor bl, bl
        col_output:
            mov dl, result[di]

            int 21h
            inc di
            inc bl
            cmp bl, rows
            jne col_output
        mov ah, 9h
        mov dx, offset newline
        int 21h

        inc bh
        add di, cx
        cmp bh, cols
        jne row_output

    mov ah, 4Ch
    int 21h

; =================================
; PROC CALCULATES THE BOTTOM LEFT CORNER OF THE MATRIX
; =================================
calc_position proc near
    push ax
    xor ah, ah
    mov al, cols
    mov di, ax
    sub di, 1

    mov ax, 9
    mul di
    mov di, ax

    pop ax
    ret
calc_position endp
codes ends
    end main
