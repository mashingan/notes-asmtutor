;; With kernel interrupt 9, dos already know the end of string when it finds
;; this version is about as before but we put the '$' after the length
;; to utilize dos ah=9 kernel interrupt

org 256

start:
    mov dx, hello
    call strlen
    mov di, hello
    add di, ax
    mov byte [di+1], '$'
    mov dx, hello
    mov ah, 9
    int 21h
.exit:
    int 20h

; need the string pointer in dx
; with result in ax
; repnz scabs will dec cx until it found so we put the cx as (unsigned) -1
strlen:
    push    cx di
    mov     cx, 0xffff
    mov     di, dx
    mov     al, 0
    repnz   scasb
    mov     ax, 0xffff
    sub     ax, cx
    pop     di cx
    ret

hello db 'Hello world!', 0h, 0h
