setStdout:
    invoke  GetStdHandle, STD_OUTPUT_HANDLE
    mov     [stdout], rax
    ret

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

quitProgram:
    invoke  ExitProcess, 0
