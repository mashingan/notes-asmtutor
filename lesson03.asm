format ELF executable 3

entry start

segment readable writeable
msg     db 'Hello the new brave isekai!', 0Ah

segment readable executable
start:
    mov     ebx, msg
    mov     eax, ebx

.nextchar:
    cmp     byte [eax], 0
    jz      .finished
    inc     eax
    jmp     .nextchar

.finished:
    sub     eax, ebx

    mov     edx, eax
    mov     ecx, ebx
    mov     ebx, 1
    mov     eax, 4
    int     80h

    mov     ebx, 0
    mov     eax, 1
    int     80h
