format ELF64 executable 3
entry start

include 'procs.inc'

segment readable writable
prompt  db  'Please enter your name: ', 0h
hello   db  'Hello, ', 0h

sinput  rb    255

segment readable executable
start:
    mov     rax, prompt
    call    sprint

    mov     edx, 255
    mov     rsi, sinput
    mov     edi, 0
    mov     eax, 0
    syscall

    mov     rax, hello
    call    sprint

    mov     rax, sinput
    call    sprint  ; input already contains linefeed

    call    quitProgram
