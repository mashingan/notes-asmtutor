format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?
fizz    db  'fizz', 0h
buzz    db  'buzz', 0h

section '.text' code readable executable
start:
    fastcall setStdout
    mov     rsi, 0
    mov     rdi, 0
    mov     rbx, 0
    mov     r12, 0

.nextNumber:
    inc     rbx

.checkFizz:
    mov     rdx, 0
    mov     rax, rbx
    mov     r12, 3
    div     r12
    mov     rdi, rdx
    cmp     rdi, 0
    jne     .checkBuzz
    mov     rcx, fizz
    call    sprint

.checkBuzz:
    mov     rdx, 0
    mov     rax, rbx
    mov     r12, 5
    div     r12
    mov     rsi, rdx
    cmp     rsi, 0
    jne     .printInteger
    mov     rcx, buzz
    call    sprint

.printInteger:
    cmp     rdi, 0
    je      .continue
    cmp     rsi, 0
    je      .continue
    mov     rcx, rbx
    call    iprint

.continue:
    mov     al, 0ah
    mov     ah, 0dh
    push    ax
    mov     rcx, rsp
    mov     rdx, 2
    fastcall snprint
    pop     ax
    cmp     rbx, 100
    jb      .nextNumber

    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
