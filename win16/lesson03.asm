;; With kernel interrupt 9, dos already know the end of string when it finds
;; the '$', but in this case we reuse the dos3.0+ internal of
;;    ax=1212h which read the length in si
;; or ax=1255h which read the length in di
;; so we emulate the print with ax=2h for print a character until cx=0
;; if we interrupt using int 2fh
;; ======
;; apparently the cx always 0 even after calling the int 2fh so we opt to 
;; manual counting which compare to '0' and '$' because dos recognize the '$'
;; as end of string

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
    mov si, hello
    mov di, cx
.printchar:
    mov bx, di
    sub bx, cx
    mov ah, 2h
    mov dl, byte [si+bx]
    int 21h
    loopw .printchar
.exit:
    int 20h

hello db 'Hello world!', 0h, 0h
