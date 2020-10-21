;; With kernel interrupt 9, dos already know the end of string when it finds
;; this version is about as before but we put the '$' after the length
;; to utilize dos ah=9 kernel interrupt

org 256

start:
    xor cx, cx
    mov si, hello
.nextchar:
    cmp byte [si], 0
    je  @f
    cmp byte [si], '$'
    je  @f
    inc cx
    inc si
    jmp .nextchar
@@:
    mov dx, hello
    mov byte [si+1], '$'
    mov ah, 9
    int 21h
.exit:
    int 20h

hello db 'Hello world!', 0h, 0h
