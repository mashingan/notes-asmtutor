; every invoke will change ever volatile register
; ref: https://docs.microsoft.com/en-us/cpp/build/x64-software-conventions?view=vs-2019#register-volatility-and-preservation
format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
msg     db 'Hello the brave to the isekai!', 0dh, 0ah, 0
stdout  dq ?

section '.text' code readable executable

start:
    invoke  GetStdHandle, STD_OUTPUT_HANDLE
    mov     [stdout], rax
    mov     rbx, msg
    mov     rcx, rbx
    fastcall strlen

    mov     rdx, rax
    mov     rcx, msg
    ;mov     rax, msg
    fastcall printString
    invoke  ExitProcess, 0

strlen:
    mov     rax, rcx

    @@:
    cmp     byte [rax], 0
    jz      @f
    inc     rax
    jmp     @b

    @@:
    sub     rax, rcx
    ret

printString:
    push    rbx rdi
    mov     rbx, rdx
    mov     rax, rcx
    invoke  WriteConsoleA, [stdout], rax, rbx, rdi, 0
    pop     rdi rbx
    ret

exitProgram:
    invoke  ExitProcess, 0

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
