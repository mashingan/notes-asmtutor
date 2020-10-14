format ELF64 executable 3
entry start

segment readable executable

start:
mov     edx, msglen
mov     rsi, msg
mov     edi, 1
mov     eax, 1
syscall

segment readable writeable
msg     db 'Hello world!', 0Ah
msglen = $ - msg
