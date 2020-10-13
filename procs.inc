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
    push    eax ecx edx esi
    cmp     eax, 0
    jg      @f
    mov     edx, eax
    mov     eax, '-'
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    mov     eax, edx
    neg     eax
@@:
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

    pop     esi edx ecx eax
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

true = 1
false = 0
atoi:
    push    ebx ecx edx esi
    mov     esi, eax
    mov     eax, 0
    mov     ecx, 0
    mov     ebx, 0
    mov     edx, 0
    mov     dl, false
    cmp     byte [esi], '-'
    jne     @f
    inc     esi
    mov     dl, true
@@:
    push    edx
@@:
    xor     ebx, ebx
    mov     bl, byte [esi+ecx]
    cmp     bl, '0'
    jl      @f
    cmp     bl, '9'
    jg      @f

    sub     bl, '0'
    add     eax, ebx
    mov     ebx, 10
    mul     ebx
    inc     ecx
    jmp     @b
@@:
    cmp     ecx, 0
    je      @f
    mov     ebx, 10
    div     ebx
@@:
    pop     edx
    cmp     dl, true
    jne     @f
    neg     eax

@@:
    pop     esi edx ecx ebx
    ret
