format ELF executable 3
entry start

include 'procs.inc'

segment readable
msg db  'Seconds since 1 January 1970: ', 0h

segment readable executable
start:
    mov     eax, msg
    call    sprint

    mov     eax, 13 ; SYS_TIME (kernel opcode 13)
    int     80h

    call    iprintLF
    call    quitProgram
