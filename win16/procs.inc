CRLF:
    push    ax dx
    mov     ah, 2
    mov     dl, 13
    int     21h
    mov     dl, 10
    int     21h
    pop     dx ax
    ret

; need the string pointer in dx
; with result in ax
; repnz scabs will dec cx until it found so we put the cx as (unsigned) -1
strlen:
    push    cx di
    mov     cx, 0xff
    mov     di, dx
    mov     al, 0
    repnz   scasb
    mov     ax, 0xff
    sub     ax, cx
    dec     ax
    pop     di cx
    ret

; need the string pointer in dx
; di as count
snprint:
    ;; older implementation
    ;push    ax bx cx
    ;mov     bx, dx
    ;mov     cx, di
    ;mov     ah, 2
;@@:
    ;mov     dl, byte [bx]
    ;inc     bx
    ;int     21h
    ;loopw   @b
    ;pop     cx bx ax
    ;ret
    push    ax bx cx
    mov     cx, di
    mov     di, dx
    mov     ah, 40h
    mov     bx, 1
    int     21h
    pop     cx bx ax
    ret

sprint:
    push    ax bx di
    mov     bx, dx
    call    strlen
    mov     di, ax
    mov     dx, bx
    call    snprint
    pop     di bx ax
    ret

sprintCRLF:
    push    bx
    mov     bx, dx
    call    sprint
    mov     dx, bx
    call    CRLF
    pop     bx
    ret
    
;; taking the single arg in dx
iprint:
    push    ax bx cx
    mov     ax, dx
    xor     cx, cx
    cmp     ax, 0
    jge     @f
    push    ax
    mov     ah, 2
    mov     dl, '-'
    int     21h
    pop     ax
    neg     ax
@@:
    inc     cx
    xor     dx, dx
    mov     bx, 10
    div     bx
    add     dx, '0'
    push    dx
    cmp     ax, 0
    jnz     @b
    mov     ah, 2
@@:
    ;mov     dx, sp
    ;mov     ah, 9
    pop     dx
    int     21h
    loopw   @b
    pop     cx bx ax
    ret

iprintCRLF:
    push    ax bx cx
    call    iprint
    call    CRLF
    pop     cx bx ax
    ret

false = 0
true = 1
atoi:
    push    bx cx di si
    mov     si, dx
    xor     ax, ax
    xor     bx, bx
    xor     cx, cx
    xor     dx, dx
    xor     di, di
    mov     di, 10
    mov     dl, false
    cmp     byte [si], '-'
    jne     @f
    mov     dl, true
    inc     si
    neg     ax
@@:
    push    dx
@@:
    xor     dx, dx
    mov     dl, byte [si+bx]
    cmp     dl, '0'
    jl      @f
    cmp     dl, '9'
    jg      @f
    inc     bx
    sub     dl, '0'
    add     ax, dx
    mul     di
    jmp     @b
@@:
    cmp     bx, 0
    je      @f
    div     di
@@:
    pop     dx
    cmp     dx, true
    jne     @f
    neg     ax
@@:
    pop     si di cx bx
    ret
