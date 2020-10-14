format ELF executable 3
entry start

include 'procs.inc'

segment readable executable
start:
    mov     ecx, 0
@@:
    inc     ecx
    mov     eax, ecx
    call    iprintLF
    cmp     ecx, 10
    jne     @b
    call    quitProgram
