format ELF executable 3
entry start

segment readable executable

start:
mov     edx, msglen
mov     ecx, msg
mov     ebx, 1
mov     eax, 4
int     80h

segment readable writeable
msg     db 'Hello world!', 0Ah
msglen = $ - msg
