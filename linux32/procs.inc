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

; ref: https://gist.github.com/DGivney/7196bd7a9f21a12c9397bdcf9ae040d2
;socket:
;    push    ecx ebx
;    push    byte 6      ; IPPROTOC_TCP
;    push    byte 1      ; SOCK_STREAM
;    push    byte 2      ; PF_INET
;    mov     ecx, esp    ; ecx as args
;    mov     ebx, 1      ; subroutine SOCKET opcode
;    mov     eax, 102    ; SYS_SOCKETCALL opcode 102
;    int     80h
;    pop     ebx ecx
;    ret
;
;bind:
;    push    ebx ecx edi
;    mov     edi, eax    ; SYS_SOCKETCALL value to edi -1 for error
;    push    dword 0x00  ; stack IP ADDRESS
;    push    word 0x2923 ; move  9001 dec onto stack PORT
;    push    word 2      ; move 2 dec onto stack AF_INET
;    mov     ecx, esp
;    push    byte 16     ; move 16 dec onto stack (arguments length)
;    push    ecx         ; push adress of arguments onto stack
;    push    edi         ; push the file descriptor onto stack
;    mov     ecx, esp    ; move address of arguments into ecx
;    mov     ebx, 2      ; subroutine BIND
;    mov     eax, 102    ; SYS_SOCKETCALL
;    int     80h
;    pop     edi ecx ebx
;    ret
;
;listen:
;    push    ebx ecx edi
;    push    byte 1
;    mov     ecx, esp
;    mov     ebx, 4
;    mov     eax, 102
;    int     80h
