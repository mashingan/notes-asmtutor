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

sprintLF:
    call    sprint
    push    eax
    mov     eax, 0Ah
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    pop     eax
    ret

exponent:
@@:
    cmp     ebx, 0
    je      @f
    mul     eax
    dec     ebx
    jmp     @b
@@:
    ret

;parseInt:

iprint:
    push    eax
    push    ecx
    push    edx
    push    esi
    mov     ecx, 0
@@:
    inc     ecx
    mov     edx, 0
    mov     esi, 10
    idiv    esi
    add     edx, '0'
    push    edx
    cmp     eax, 0
    jnz     @b
@@:
    dec     ecx
    mov     eax, esp
    call    sprint
    pop     eax
    cmp     ecx, 0
    jnz     @b

    pop     esi
    pop     edx
    pop     ecx
    pop     eax
    ret

iprintLF:
    call    iprint
    push    eax
    mov     eax, 0Ah
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    pop     eax
    ret
