

; lea ax, [0]  == вычисляет эффективный адрес
;
; mov ax, 0  (0 занимает 2 байта)
;
; sub ax, ax
;
; xor ax, ax   == побитовое исключающее или. Не быстрее, но занимет меньше памяти.
;