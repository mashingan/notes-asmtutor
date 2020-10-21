org 256

start:
    mov     dx, 90
    mov     ax, 9
    sub     dx, ax
    call    iprintCRLF
    int     21h

include 'procs.inc'
