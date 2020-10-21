org 256

start:
    xor     cx, cx
    xor     ax, ax
    mov     bx, sinput
    mov     dx, prompt
    call    sprint
input:
    ;mov	    ah, 08h	; no echo keyboard
    mov     ah, 01h	; take a character from keyboard
    int	    21h
    inc	    cx
    mov	    dh, al
    cmp	    al, 13
    je	    .printTxt
    mov	    [bx], dh
    inc	    bx
    cmp	    cx, txtlen
    jb	    input

.printTxt:
    call    CRLF
    mov     dx, hello
    call    sprint
    mov     di, cx
    mov     dx, sinput
    call    sprintCRLF
    int     20h

include 'procs.inc'
prompt  db  'Please enter your name: ', 0h
hello   db  'Hello, ', 0h

sinsize = 255
sinput db sinsize dup (0)
txtlen = $ - sinput
