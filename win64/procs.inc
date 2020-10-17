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
    invoke  WriteConsoleA, [stdout], [msgaddr], [len], rbx, 0
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

proc sprintWLF
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
    xorc    r12
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
    xorc    rbx
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
    mov     rdx, 1
    fastcall snprint
    pop     ax
    ret
endp

quitProgram:
    invoke  ExitProcess, 0
