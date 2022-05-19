bits 64

[list -]
     %define   GTK_WINDOW_TOPLEVEL   0
     %define   GTK_WIN_POS_CENTER    1
     %define   FALSE                 0
     %define   TRUE                  1
     
     extern    exit
     extern    gtk_init
     extern    gtk_window_new
     extern    gtk_window_set_title
     extern    gtk_window_set_default_size
     extern    gtk_window_set_position
     extern    gtk_button_new_with_label
     extern    gtk_container_set_border_width
     extern    gtk_box_new
     extern    gtk_container_add
     extern    gtk_button_new_with_label
     extern    g_signal_connect_data
     extern    gtk_box_pack_start
     extern    gtk_container_add
     extern    gtk_widget_show_all
     extern    gtk_main
     extern    gtk_main_quit
     extern    gtk_label_new
     extern    gtk_entry_new
     extern    gtk_entry_get_text
     extern    gtk_label_set_text
     extern    g_printf
     extern    atoi
     extern    sprintf
[list +]    

section .data
    window:
      .handle:     dq  0
      .title:      db  "GtkVBox",0
    vbox:
      .handle:     dq  0
    first_enrty:
      .handle:     dq  0
    second_entry:
      .handle:     dq  0
    addition:
      .handle:     dq  0
      .label:      db  "Сложить", 0
    res_label:
      .handle:     dq  0
      .label:      db  "Result", 0
    signal:
      .destroy:    db  "destroy", 0
      .clicked:    db  "clicked", 0
    format:        db  "%d", 0
    
section .text
    global _start

_start:
    xor     rsi, rsi                  ; argv
    xor     rdi, rdi                  ; argc
    call    gtk_init
    
    mov     rdi, GTK_WINDOW_TOPLEVEL
    call    gtk_window_new
    mov     QWORD[window.handle], rax

    mov     rdi, res_label.label
    call    gtk_label_new
    mov     QWORD[res_label.handle], rax

    mov     rdi, QWORD[window.handle]
    mov     rsi, window.title
    call    gtk_window_set_title

    mov     rdi, qword [window.handle]
    mov     rsi, 600
    mov     rdx, 200
    call    gtk_window_set_default_size

    mov     rdi, QWORD[window.handle]
    mov     rsi, GTK_WIN_POS_CENTER
    call    gtk_window_set_position

    mov     rdi, qword[window.handle]
    mov     rsi, 5
    call    gtk_container_set_border_width
    
    mov     rdi, TRUE
    mov     rsi, 1
    call    gtk_box_new
    mov     qword[vbox.handle], rax
    
    mov     rdi, qword[window.handle]
    mov     rsi, qword[vbox.handle]
    call    gtk_container_add

    call    gtk_entry_new
    mov     qword[first_enrty.handle], rax

    call    gtk_entry_new
    mov     qword[second_entry.handle], rax
    
    mov     rdi, addition.label
    call    gtk_button_new_with_label
    mov     qword[addition.handle], rax

    mov     rdi, qword[vbox]
    mov     rsi, qword[first_enrty.handle]
    mov     rdx, TRUE
    mov     rcx, TRUE
    xor     r8, r8
    xor     r9, r9
    call    gtk_box_pack_start

    mov     rdi, qword[vbox]
    mov     rsi, qword[second_entry.handle]
    mov     rdx, TRUE
    mov     rcx, TRUE
    xor     r8, r8
    xor     r9, r9
    call    gtk_box_pack_start

    mov     rdi, qword[vbox]
    mov     rsi, qword[addition.handle]
    mov     rdx, TRUE
    mov     rcx, TRUE
    xor     r8, r8
    xor     r9, r9
    call    gtk_box_pack_start

    mov     rdi, qword[vbox]
    mov     rsi, qword[res_label.handle]
    mov     rdx, TRUE
    mov     rcx, TRUE
    xor     r8, r8
    xor     r9, r9
    call    gtk_box_pack_start

    xor     r9d, r9d
    xor     r8d, r8d
    xor     rcx, rcx
    ;mov     rcx, qword[window.handle]
    mov     rdx, event_clicked
    mov     rsi, signal.clicked
    mov     rdi, qword[addition.handle]
    call    g_signal_connect_data
    
    xor     r9d, r9d                       ; combination of GConnectFlags 
    xor     r8d, r8d                       ; a GClosureNotify for data
    xor     rcx, rcx                       ; pointer to the data to pass
    mov     rdx, gtk_main_quit             ; pointer to the handler
    mov     rsi, signal.destroy            ; pointer to the signal
    mov     rdi, QWORD[window.handle]      ; pointer to the widget instance
    call    g_signal_connect_data          ; the value in RAX is the handler, but we don't store it now
       
    mov     rdi, QWORD[window.handle]
    call    gtk_widget_show_all

    call    gtk_main

    xor     rdi, rdi                ; we don't expect much errors now thus errorcode=0
    call    exit

event_clicked:
    push    rbp
    mov     rbp, rsp

    mov     rdi, qword[first_enrty.handle]
    call    gtk_entry_get_text

    mov     rdi, rax
    call    atoi

    mov     rbx, rax

    mov     rdi, qword[second_entry.handle]
    call    gtk_entry_get_text

    mov     rdi, rax
    call    atoi

    add     rax, rbx

    mov     rdx, rax
    mov     rsi, format
    mov     rdi, buf
    call    sprintf


    xor     r9d, r9d
    xor     r8d, r8d
    xor     rcx, rcx
    mov     rsi, buf
    mov     rdi, qword[res_label.handle]
    call    gtk_label_set_text

    mov     rsp, rbp
    pop     rbp
    ret

section .bss
    buf     resb 100
