format ELF executable 3
entry start

include 'procs.inc'

segment readable executable
start:
    mov     eax, 90
    sub     eax, 9
    call    iprintLF
    call    quitProgram
