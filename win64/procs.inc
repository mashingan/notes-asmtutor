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

quitProgram:
    invoke  ExitProcess, 0
