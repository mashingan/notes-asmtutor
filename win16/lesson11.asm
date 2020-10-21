org 256

start:
    mov     cx, 10
@@:
    mov     dx, 11
    sub     dx, cx
    call    iprintCRLF
    loopw   @b

    int     20h

include 'procs.inc'
