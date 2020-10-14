format ELF executable 3

entry start

segment readable writable
msg     db 'Hello world!', 0Ah
msglen = $ - msg

segment readable executable
start:
mov     edx, msglen
mov     ecx, msg
mov     ebx, 1
mov     eax, 4
int     80h

mov     ebx, 0
mov     eax, 1
int     80h
