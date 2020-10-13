format ELF executable 3
entry start

include 'procs.inc'

segment readable
banner  db '<lesson16> <arg1> <arg2> ...:', 0Ah, 0
gotMinus db 'minus: ', 0

segment readable executable
start:
    mov     eax, banner
    call    sprint
    pop     ecx
    pop     edx     ; second value on the stack is program name
    dec     ecx     ; without program name
    mov     edx, 0
@@:
    cmp     ecx, 0h
    jz      @f
    pop     eax
    call    atoi

    cmp     eax, 0
    jg      .notminus
    mov     ebx, eax
    mov     eax, gotMinus
    call    sprint
    mov     eax, ebx
    call    iprintLF
    mov     eax, ebx

.notminus:
    add     edx, eax
    dec     ecx
    jmp     @b
@@:
    mov     eax, edx
    call    iprintLF
    call    quitProgram
