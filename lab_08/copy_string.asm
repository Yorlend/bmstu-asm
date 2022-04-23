global copy_string

section .text

copy_string:
    push rbp
    mov rbp, rsp
    
    mov rcx, rdx

    cmp rsi, rdi
    je end_copying
    jg no_overlapping

    std
    add rsi, rcx
    add rdi, rcx

    no_overlapping:
        inc rcx
        rep movsb

    end_copying:
        cld
        pop rbp
        ret
