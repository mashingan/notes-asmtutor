format ELF executable 3
entry start

include 'procs.inc'

segment readable
filename    db  'filecreate.txt', 0h

segment readable executable
start:
    mov     ebx, filename
    mov     eax, 10         ; SYS_UNLINK
    int     80h

    call    quitProgram
