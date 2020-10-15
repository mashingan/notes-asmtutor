format ELF64 executable 3
entry start

include 'procs.inc'

segment readable
banner  db '<lesson16> <arg1> <arg2> ...:', 0Ah, 0
gotMinus db 'minus: ', 0

segment readable executable
start:
    mov     rax, banner
    call    sprint
    pop     rbx
    pop     rdx     ; second value on the stack is program name
    dec     rbx     ; without program name
    mov     rdx, 0
@@:
    cmp     rbx, 0h
    jz      @f
    pop     rax
    call    atoi

    cmp     rax, 0
    jg      .notminus
    mov     rdi, rax
    mov     rax, gotMinus
    call    sprint
    mov     rax, rdi
    call    iprintLF
    mov     rax, rdi

.notminus:
    add     rdx, rax
    dec     rbx
    jmp     @b
@@:
    mov     rax, rdx
    call    iprintLF
    call    quitProgram
