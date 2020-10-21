org 256

start:
    mov     cl, 10
    mov     ah, 02h
@@:
    mov     dl, 11
    sub     dl, cl
    add     dl, '0'
    int     21h
    call    CRLF
    loopw   @b

    int     20h

CRLF:
    push    ax bx cx
    mov     ah, 02h
    mov     dl, 13
    int     21h
    mov     dl, 10
    int     21h
    pop     cx bx ax
    ret
