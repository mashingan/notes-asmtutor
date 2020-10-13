format ELF executable 3
entry start

include 'procs.inc'

segment readable executable
start:
    pop     ecx
@@:
    cmp     ecx, 0h
    jz      @f
    pop     eax
    call    sprintLF
    dec     ecx
    jmp     @b
@@:
    call    quitProgram
