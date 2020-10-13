format ELF executable 3
entry start

segment readable writeable
msg     db 'Hello the brave to the isekai!', 0Ah

segment readable executable

start:
    mov     ebx, msg
    mov     eax, ebx
    call    strlen

    mov     edx, eax
    mov     ecx, ebx
    call    printString
    jmp     exitProgram

strlen:
    push    ebx
    mov     ebx, eax

    @@:
    cmp     byte [eax], 0
    jz      @f
    inc     eax
    jmp     @b

    @@:
    sub     eax, ebx
    pop     ebx
    ret

printString:
    push    ebx
    mov     ebx, 1
    mov     eax, 4
    int     80h
    pop     ebx
    ret

exitProgram:
    mov     ebx, 0
    mov     eax, 1
    int     80h
