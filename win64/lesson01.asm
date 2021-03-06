format PE64 console
entry start
include 'win64w.inc'

section '.data' data readable writeable
hello   db  'Hello world!', 0dh, 0ah, 0
len = $ - hello

section '.text' code readable executable
start:
    invoke  GetStdHandle, STD_OUTPUT_HANDLE
    push    0
    mov     rbx, rsp
    invoke  WriteConsoleA, rax, hello, len, rbx, 0
    pop     rbx

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
