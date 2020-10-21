org 256

start:
    mov     ax, 90
    mov     bx, 9
    xor     dx, dx
    div     bx
    mov     bx, dx
    mov     dx, divi
    call    sprint
    mov     dx, ax
    call    iprintCRLF
    mov     dx, rema
    call    sprint
    mov     dx, bx
    call    iprintCRLF
    int     20h

include 'procs.inc'

divi db '90 div 9 is ', 0h
rema db 'remain with ', 0h
