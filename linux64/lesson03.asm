format ELF64 executable 3
entry start

include 'procs.inc'

segment readable writeable
msg     db 'Hello the new brave isekai!', 0Ah, 0

segment readable executable
start:
    mov     rbx, msg
    mov     rax, rbx

.nextchar:
    cmp     byte [rax], 0
    jz      .finished
    inc     rax
    jmp     .nextchar

.finished:
    sub     rax, rbx

    mov     rdx, rax
    mov     rsi, rbx
    mov     edi, 1
    mov     eax, 1
    syscall

    xorc    rdi
    mov     eax, 60
    syscall
