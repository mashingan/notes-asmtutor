; every invoke will change ever volatile register
; ref: https://docs.microsoft.com/en-us/cpp/build/x64-software-conventions?view=vs-2019#register-volatility-and-preservation
; this version is using the proc/endp macro to allocate the stack for
; local variable
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
    mov     rcx, msg
    fastcall strlen

    mov     rdx, rax
    mov     rcx, msg
    fastcall printString
    fastcall exitProgram

proc strlen msgaddr
    mov     rax, rcx

    @@:
    cmp     byte [rax], 0
    jz      @f
    inc     rax
    jmp     @b

    @@:
    sub     rax, rcx
    ret
endp

proc printString msgaddr, len
    mov     [msgaddr], rcx
    mov     [len], rdx
    push    rbx
    invoke  WriteConsoleA, [stdout], [msgaddr], [len], rbx, 0
    ret
endp

exitProgram:
    invoke  ExitProcess, 0

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
