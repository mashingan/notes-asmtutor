format ELF64 executable 3
entry start

include 'procs.inc'

segment readable executable
start:
    mov     rdx, 0
@@:
    inc     rdx
    mov     rax, rdx
    call    iprintLF
    cmp     rdx, 10
    jne     @b
    call    quitProgram
