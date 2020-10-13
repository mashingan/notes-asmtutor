format ELF executable 3
entry start

include 'procs.inc'

segment readable writable
prompt  db  'Please enter your name: ', 0h
hello   db  'Hello, ', 0h

sinput  rb    255

segment readable executable
start:
    mov     eax, prompt
    call    sprint

    mov     edx, 255
    mov     ecx, sinput
    mov     ebx, 0
    mov     eax, 3
    int     80h

    mov     eax, hello
    call    sprint

    mov     eax, sinput
    call    sprint  ; input already contains linefeed

    call    quitProgram
