org 256

start:
    mov     dx, banner
    call    sprint
    xor     ch, ch
    xor     dx, dx
    mov     cl, [ds:0080h]
    lea     dx, [ds:0081h]
    mov     di, cx
    call    parseCmdToken
    mov     dx, ax
    call    iprintCRLF
    int     20h

include 'procs.inc'

;; need the dx as the stringptr
;; need the di as the count
virtual at bp-6
    origsi dw ?
end virtual

virtual at bp-2
    len dw ?
end virtual

virtual at bp-4
    res dw ?
end virtual

virtual at bp-64-6
    localbuf dw ?
end virtual

parseCmdToken:
    push    bx cx si
    enter   64+6, 0
    and     sp, -16 ; 16-bit aligned
    mov     [origsi], dx
    mov     [len], di
    mov     [res], 0
    lea     di, [localbuf]
    xor     bx, bx
    xor     ax, ax
    mov     cx, [len]
    mov     si, dx

.discardFirstArg:
    ;inc     si
    ;cmp     byte [si], 0
    ;je      .exitParse
    ;cmp     byte[si], ' '
    ;jne      .discardFirstArg

.discardSpace1:
    inc     si
    cmp     byte [si], 0
    je      .exitParse
    cmp     byte [si], ' '
    je      .discardSpace1
    cmp     byte [si], 13
    je      .exitParse
.getANum:
    cmp     byte [si], 0
    je      .next
    cmp     byte [si], 13
    je      .next
    cmp     byte [si], ' '
    je      .next
    inc     bx
    movsb
    jmp     .getANum
.next:
    sub     di, bx
    mov     dx, di
    call    atoi
    add     [res], ax
    lea     di, [localbuf]
    mov     cx, bx
    mov     al, 0
    rep     stosb
    lea     di, [localbuf]
    xor     bx, bx
    jmp     .discardSpace1
.exitParse:
    mov     ax, [res]
    leave
    pop     si cx bx
    ret

banner  db '<lesson16> <arg1> <arg2> ...:', 0dh, 0Ah, 0
