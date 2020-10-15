format ELF64 executable 3
entry start

include 'procs.inc'

segment readable executable
start:
    mov     eax, 90
    add     eax, 9
    call    iprintLF
    call    quitProgram
