org 256

start:
    mov     ax, 90
    mov     dx, 9
    mul     dx
    mov     dx, ax
    call    iprintCRLF
    int     21h

include 'procs.inc'
