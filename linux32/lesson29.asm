format ELF executable 3
entry start

include 'procs.inc'

macro xorc reg {
    xor     reg, reg
}

segment readable executable
start:
    xorc    eax
    xorc    ebx
    xorc    edi
    xorc    esi

.socket:
    push    6           ; IPPROTO_TCP
    push    1           ; SOCK_STREAM
    push    2           ; PF_INET
    mov     ecx, esp    ; move address of argument into ecx
    mov     ebx, 1      ; subroutine SOCKET (1)
    mov     eax, 102    ; SYS_SOCKETCALL kernel opcode 102
    int     80h         ; call the kernel

    call    iprintLF

    call    quitProgram
