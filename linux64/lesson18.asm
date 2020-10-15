format ELF64 executable 3
entry start

include 'procs.inc'

segment readable
fizz    db  'fizz', 0h
buzz    db  'buzz', 0h

segment readable executable
start:
    mov     rsi, 0
    mov     rdx, 0
    mov     rbx, 0

.nextNumber:
    inc     rbx

.checkFizz:
    mov     rdx, 0
    mov     rax, rbx
    mov     rcx, 3
    div     rcx
    mov     rdi, rdx
    cmp     rdi, 0
    jne     .checkBuzz
    mov     rax, fizz
    call    sprint

.checkBuzz:
    mov     rdx, 0
    mov     rax, rbx
    mov     rcx, 5
    div     rcx
    mov     rsi, rdx
    cmp     rsi, 0
    jne     .printInteger
    mov     rax, buzz
    call    sprint

.printInteger:
    cmp     rdi, 0
    je      .continue
    cmp     rsi, 0
    je      .continue
    mov     rax, rbx
    call    iprint

.continue:
    mov     rax, 0Ah
    push    rax
    mov     rax, rsp
    call    sprint
    pop     rax
    cmp     rbx, 100
    jb      .nextNumber

    call    quitProgram
