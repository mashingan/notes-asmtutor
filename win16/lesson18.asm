org 256

start:
    xor     bx, bx
.continue:
    inc     bx
    xor     dx, dx
    mov     cx, 3
    mov     ax, bx
    div     cx
    push    dx
    cmp     dx, 0
    jne     @f
    mov     dx, fizz
    call    sprint
@@:
    xor     dx, dx
    mov     cx, 5
    mov     ax, bx
    div     cx
    cmp     dx, 0
    push    dx
    jne     @f
    mov     dx, buzz
    call    sprint
@@:
    pop     dx
    cmp     dx, 0
    je      @f
    pop     dx
    cmp     dx, 0
    je      @f
    mov     dx, bx
    call    iprint
@@:
    call    CRLF
    cmp     bx, 100
    jb     .continue
    int     20h

include 'procs.inc'

fizz db 'fizz',0h
buzz db 'buzz',0h
