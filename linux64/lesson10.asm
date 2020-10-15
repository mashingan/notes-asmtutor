format ELF64 executable 3
entry start

include 'procs.inc'

segment readable writable
banner  db  'Count and print each line to 10', 0

start:
    mov     rax, banner
    call    sprintLF
    mov     rdx, 0
@@:
    inc     rdx
    cmp     rdx, 10
    jg      @f
    mov     rax, rdx
    add     rax, '0'
    push    rax
    mov     rax, rsp
    call    sprintLF
    pop     rax
    jne     @b
@@:
    call    quitProgram
