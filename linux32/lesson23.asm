format ELF executable 3
entry start

include 'procs.inc'

segment readable
filename    db  'filecreate.txt', 0h
content     db  'hello world!', 0h
content.length = $ - content

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

    call    quitProgram
