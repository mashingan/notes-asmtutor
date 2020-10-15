macro xorc reg {
    xor reg, reg
}

slen:
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

snprint:
    push    rdi rsi rdx
    mov     rdx, rbx
    mov     rsi, rax
    mov     rdi, 1
    mov     rax, 1
    syscall
    pop     rdx rsi rdi
    ret

sprint:
    push    rbx
    push    rax
    call    slen
    mov     rbx, rax
    pop     rax
    call    snprint
    pop     rbx
    ret

sprintLF:
    push    rbx
    call    sprint
    mov     rax, 0ah
    push    rax
    mov     rax, rsp
    mov     rbx, 1
    call    snprint
    pop     rax
    pop     rbx
    ret

i1print:
    push    rbx rdx
    mov     rdx, rax
    add     rdx, '0'
    push    rdx
    mov     rax, rsp
    mov     rbx, 1
    call    snprint
    pop     rax
    pop     rdx rbx
    ret

i1printLF:
    push    rbx rdx
    mov     rdx, rax
    call    i1print
    mov     rax, 0ah
    push    rax
    mov     rax, rsp
    mov     rbx, 1
    call    snprint
    pop     rax
    pop     rdx rbx
    ret

quitProgram:
    xorc    rdi
    mov     rax, 60
    syscall
