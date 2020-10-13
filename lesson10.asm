format ELF executable 3
entry start

include 'procs.inc'

segment readable writable
banner  db  'Count and print each line to 10', 0

start:
    mov     eax, banner
    call    sprintLF
    mov     ecx, 0
@@:
    inc     ecx
    cmp     ecx, 10
    jg      @f
    mov     eax, ecx
    add     eax, '0'
    push    eax
    mov     eax, esp
    call    sprintLF
    pop     eax
    jne     @b
@@:
    call    quitProgram
