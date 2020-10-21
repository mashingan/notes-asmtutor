org 256

virtual at bp-sinsize
    inputPtr dw ?
end virtual

start:
    enter   sinsize, 0
    and     sp, -16
    xor     cx, cx
    xor     ax, ax
    lea     bx, [inputPtr]
    mov     dx, prompt
    call    sprint
input:
    mov     ah, 01h
    int	    21h
    inc	    cx
    mov	    dh, al
    cmp	    al, 13
    je	    .printTxt
    mov	    [bx], dh
    inc	    bx
    cmp	    cx, sinsize
    jb	    input

.printTxt:
    call    CRLF
    mov     dx, hello
    call    sprint
    mov     di, cx
    lea     dx, [inputPtr]
    call    snprint
    leave
    int     20h

include 'procs.inc'
prompt  db  'Please enter your name: ', 0h
hello   db  'Hello, ', 0h

sinsize = 255
