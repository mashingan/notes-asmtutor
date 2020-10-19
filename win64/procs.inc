setStdout:
    invoke  GetStdHandle, STD_OUTPUT_HANDLE
    mov     [stdout], rax
    ret

proc setStdin localstdin
    mov     [localstdin], rcx
    invoke  GetStdHandle, STD_INPUT_HANDLE
    mov     rcx, [localstdin]
    mov     [rcx], rax
    ret
endp

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
    push    0
    mov     rbx, rsp
    invoke  WriteConsoleA, [stdout], [msgaddr], [len], rbx, 0
    pop     rbx
    pop     rbx
    ret
endp

proc sprint msgaddr
    mov     [msgaddr], rcx
    fastcall strlen
    mov     rcx, [msgaddr]
    mov     rdx, rax
    fastcall snprint
    ret
endp

snprint = printString

proc snprintW msgaddr, len
    mov     [msgaddr], rcx
    mov     [len], rdx
    push    rbx
    invoke  WriteConsoleW, [stdout], [msgaddr], [len], rbx, 0
    pop     rbx
    ret
endp

proc snprintLF
    fastcall snprint
    mov     al, 0ah
    mov     ah, 0dh
    push    ax
    mov     rcx, rsp
    mov     rdx, 2
    fastcall snprint
    pop     ax
    ret
endp

proc sprintLF
    fastcall sprint
    mov     al, 0ah
    mov     ah, 0dh
    push    ax
    mov     rcx, rsp
    mov     rdx, 2
    fastcall snprint
    pop     ax
    ret
endp

proc snprintWLF
    fastcall snprintW
    mov     al, 0ah
    mov     ah, 0dh
    push    ax
    mov     rcx, rsp
    mov     rdx, 2
    fastcall snprint
    pop     ax
    ret
endp

proc iprint
    push    rbx rdi r12
    mov     rax, rcx
    xor     r12, r12
    cmp     rax, 0
    jge     @f
    mov     rbx, rax
    mov     rax, '-'
    push    rax
    mov     rdx, 1
    mov     rcx, rsp
    fastcall snprint
    pop     rax     ; discard it
    mov     rax, rbx
    neg     rax
    xor     rbx, rbx
@@:
    inc     r12
    mov     rdx, 0
    mov     rdi, 10
    div     rdi
    add     rdx, '0'
    push    rdx
    cmp     rax, 0
    jnz     @b
    mov     rdx, r12
@@:
    dec     r12
    mov     rcx, rsp
    mov     rdx, 1
    fastcall snprint
    pop     rax
    cmp     r12, 0
    jg      @b

    pop     r12 rdi rbx
    ret
    
endp

proc iprintLF
    fastcall iprint
    mov     al, 0ah
    mov     ah, 0dh
    push    ax
    mov     rcx, rsp
    mov     rdx, 2
    fastcall snprint
    pop     ax
    ret
endp

false = 0
true = 1

proc atoi
    push    rbx rdi rsi
    mov     rsi, rcx
    xor     rax, rax
    xor     rbx, rbx
    xor     rcx, rcx
    xor     rdx, rdx
    xor     rdi, rdi
    mov     rdi, 10
    mov     dl, false
    cmp     byte [rsi], '-'
    jne     @f
    mov     dl, true
    inc     rsi
@@:
    push    rdx
@@:
    xor     rdx, rdx
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
    pop     rsi rdi rbx
    ret
endp

quitProgram:
    invoke  ExitProcess, 0
