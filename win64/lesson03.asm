format PE64 console
entry start
include 'win64w.inc'

section '.data' readable
msg     db 'Hello the new brave isekai!', 0dh, 0Ah, 0

section '.text' code readable executable
start:
    mov     rbx, msg
    mov     rcx, rbx

.nextchar:
    cmp     byte [rcx], 0
    jz      .finished
    inc     rcx
    jmp     .nextchar

.finished:
    sub     rcx, rbx
    invoke  GetStdHandle, STD_OUTPUT_HANDLE
    push    0
    mov     rbx, rsp
    invoke  WriteConsoleA, rax, msg, rcx, rbx, 0
    pop     rax ; discard
    invoke  ExitProcess, 0

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
