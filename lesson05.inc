slen:
    push    ebx
    mov     ebx, eax
    @@:
    cmp     byte[eax], 0
    jz      @f
    inc     eax
    jmp     @b
    @@:
    sub     eax, ebx
    pop     ebx
    ret

sprint:
    push    ebx
    push    ecx
    push    edx
    mov     ecx, eax
    call    slen
    mov     edx, eax
    mov     ebx, 1
    mov     eax, 4
    int     80h
    pop     edx
    pop     ecx
    pop     ebx
    ret

quitProgram:
    mov     ebx, 0
    mov     eax, 1
    int     80h
