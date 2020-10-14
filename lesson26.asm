format ELF executable 3
entry start

include 'procs.inc'

segment readable
filename    db  'filecreate.txt', 0h
content     db  'hello world!', 0h
content.length = $ - content

segment readable writeable

filecontent rb  255
            db  0h

segment readable executable
start:
    mov     ecx, 0777
    mov     ebx, filename
    mov     eax, 8
    int     80h

    mov     edx, content.length
    mov     ecx, content
    mov     ebx, eax
    mov     eax, 4
    int     80h

    mov     ecx, 0      ; read only
    mov     ebx, filename
    mov     eax, 5
    int     80h

    mov     edx, 12
    mov     ecx, filecontent
    mov     ebx, eax
    mov     eax, 3
    int     80h

    mov     eax, filecontent
    call    sprintLF

    mov     ebx, ebx    ; to illustrate SYS_CLOSE
                        ; needs file descriptor from ebx
    mov     eax, 6
    int     80h
    call    quitProgram
