format ELF64 executable 3
entry start

include 'procs.inc'

segment readable writeable
msg     db 'Hello the brave to the isekai!', 0Ah, 0

segment readable executable

start:
    mov     rbx, msg
    mov     rax, rbx
    call    strlen

    mov     rdx, rax
    mov     rsi, rbx
    call    printString
    jmp     exitProgram

strlen:
    push    rbx
    mov     rbx, rax

    @@:
    cmp     byte [rax], 0
    jz      @f
    inc     rax
    jmp     @b

    @@:
    sub     rax, rbx
    pop     rbx
    ret

printString:
    push    rdi
    mov     edi, 1
    mov     eax, 1
    syscall
    pop     rdi
    ret

exitProgram:
    xorc    rdi
    mov     eax, 60
    syscall
