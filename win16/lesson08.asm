;; ref: https://stackoverflow.com/a/52860507
org 256

start:
    mov     ah, 40h
    mov     bx, 1
    xor     ch, ch
    mov     cl, [ds:0080h]
    lea     dx, [ds:0081h]
    int     21h

    mov     ax, 4c00h   ; ah=4c, al=00 (exit 0)
    int     21h

include 'procs.inc'
