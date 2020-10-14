format ELF executable 3
entry start

include 'procs.inc'

segment readable
filename    db  'filecreate.txt', 0h
newcontents db  0Ah, '-updated-', 0h
newcon.len  = $ - newcontents

segment readable executable
start:
    mov     ecx, 1          ; O_WRONLY
    mov     ebx, filename
    mov     eax, 5          ; SYS_OPEN
    int     80h

    mov     edx, 2  ; SEEK_END
    mov     ecx, 0  ; move cursor 0 bytes
    mov     ebx, eax
    mov     eax, 19 ; SYS_LSEEK
    int     80h

    mov     edx, newcon.len
    mov     ecx, newcontents
    mov     ebx, ebx
    mov     eax, 4
    int     80h

    call    quitProgram
