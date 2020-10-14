format ELF executable 3
entry start

include 'procs.inc'

segment readable executable
start:
    mov     eax, 90
    mov     ebx, 9
    mul     ebx
    call    iprintLF
    call    quitProgram
