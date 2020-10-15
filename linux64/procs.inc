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

iprint:
    push    rbx rdi rdx
    xorc    rbx
    cmp     rax, 0
    jge     @f
    mov     rdx, rax
    mov     rax, '-'
    push    rax
    mov     rbx, 1
    mov     rax, rsp
    call    snprint
    pop     rax     ; discard it
    mov     rax, rdx
    neg     rax
    xorc    rbx
@@:
    inc     rbx
    mov     rdx, 0
    mov     rdi, 10
    div     rdi
    add     rdx, '0'
    push    rdx
    cmp     rax, 0
    jnz     @b
    mov     rdx, rbx
@@:
    dec     rdx
    mov     rax, rsp
    mov     rbx, 1
    call    snprint
    pop     rax
    cmp     rdx, 0
    jg      @b

    pop     rdx rdi rbx
    ret

iprintLF:
    push    rbx
    call    iprint
    mov     rbx, 1
    mov     rax, 0ah
    push    rax
    mov     rax, rsp
    call    snprint
    pop     rax
    pop     rbx
    ret

false = 0
true = 1
atoi:
    push    rbx rcx rdx rdi rsi
    mov     rsi, rax
    xorc    rax
    xorc    rbx
    xorc    rcx
    xorc    rdx
    xorc    rdi
    mov     rdi, 10
    mov     dl, false
    cmp     byte [rsi], '-'
    jne     @f
    mov     dl, true
    inc     rsi
@@:
    push    rdx
@@:
    xorc    rdx
    mov     dl, byte [rsi+rbx]
    cmp     dl, '0'
    jl      @f
    cmp     dl, '9'
    jg      @f
    inc     rbx
    sub     dl, '0'
    add     rax, rdx
    ;mov     rdi, 10
    mul     rdi
    jmp     @b
@@:
    cmp     rbx, 0
    je      @f
    div     rdi
@@:
    pop     rdx
    cmp     rdx, true
    jne     @f
    neg     rax
@@:
    pop     rsi rdi rdx rcx rbx
    ret

quitProgram:
    xorc    rdi
    mov     rax, 60
    syscall


O_ACCMOD = 00000003
O_RDONLY = 00000000
O_WRONLY = 00000001
O_RDWR	 = 00000002
O_CREAT	 = 00000100
O_EXCL	 = 00000200	
O_NOCTTY = 00000400	
O_TRUNC	 = 00001000	
O_APPEND = 00002000
O_NONBLOCK  = 00004000
O_DSYNC	    = 00010000
FASYNC	    = 00020000
O_DIRECT    = 00040000
O_LARGEFILE = 00100000
O_DIRECTORY = 00200000
O_NOFOLLOW  = 00400000	
O_NOATIME   = 01000000
O_CLOEXEC   = 02000000	
