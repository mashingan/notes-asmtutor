format ELF executable 3
entry start

include 'procs.inc'

segment readable
filename    db  'filecreate.txt', 0h

segment readable executable
start:
    mov     ecx, 0777   ; set all permission read, write execute
    mov     ebx, filename
    mov     eax, 8
    int     80h

    call    quitProgram
