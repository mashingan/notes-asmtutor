format ELF64 executable 3
entry start

include 'procs.inc'

segment readable writable
msg     db 'Hello world!', 0Ah
msglen = $ - msg

segment readable executable
start:
    mov     edx, msglen
    mov     rsi, msg
    mov     edi, 1
    mov     eax, 1
    syscall
    
    xorc    edi
    mov     eax, 60
    syscall
