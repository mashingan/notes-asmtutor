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
    push    ax bx cx
    mov     bx, dx
    mov     cx, di
    mov     ah, 2
@@:
    mov     dl, byte [bx]
    inc     bx
    int     21h
    loopw   @b
    pop     cx bx ax
    ret

sprint:
    push    ax di
    mov     di, dx
    call    strlen
    mov     di, ax
    call    snprint
    pop     di ax
    ret
    
;true = 1
;false = 0
;; taking the single arg in dx
iprint:
    push    ax bx cx
    mov     ax, dx
    xor     cx, 0
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
