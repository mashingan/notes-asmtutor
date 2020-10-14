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

.bind:
    mov     edi, eax    ; move retval from SYS_SOCKETCALL, -1 for error
    push    0           ; push 0 to stack IP ADDRESS (0.0.0.0)
    push    word 0x2923 ; push 9001 dec onto stack PORT (reverse byte order)
    push    word 2      ; push 2 dec onto stack AF_INET
    mov     ecx, esp    ; move address of stack pointer to ecx
    push    16          ; push 16 dec onto stack arguments
    push    ecx         ; push the address of arguments onto stack
    push    edi
    mov     ecx, esp
    mov     ebx, 2      ; subroutine BIND (2)
    mov     eax, 102
    int     80h

.listen:
    push    1       ; move 1 onto the stack (max queue length argument)
    push    edi     ; push the file descriptor onto stack
    mov     ecx, esp
    mov     ebx, 4  ; subroutine LISTEN (4)
    mov     eax, 102
    int     80h

.accept:
    push    0       ; push 0 dec onto stack (addr length argument)
    push    0       ; push 0 dec onto stack (adress argument)
    push    edi     ; push the file descriptor onto stack
    mov     ecx, esp
    mov     ebx, 5  ; subroutine ACCEPT (5)
    mov     eax, 102
    int     80h

    call    quitProgram
