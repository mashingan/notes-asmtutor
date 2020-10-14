format ELF executable 3
entry start

include 'procs.inc'

macro xorc reg {
    xor     reg, reg
}

segment readable writable
request db 'GET / HTTP/1.1', 0dh, 0ah, 'Host: 139.162.39.66:80'
rept 2 {
    db  0dh, 0ah
}
    db 0h
request.length = $ - request
buffer  rb  4096

segment readable executable
start:
    xorc    eax
    xorc    ebx
    xorc    edi
    xorc    ecx

.socket:
    push    6           ; IPPROTO_TCP
    push    1           ; SOCK_STREAM
    push    2           ; PF_INET
    mov     ecx, esp    ; move address of argument into ecx
    mov     ebx, 1      ; subroutine SOCKET (1)
    mov     eax, 102    ; SYS_SOCKETCALL kernel opcode 102
    int     80h         ; call the kernel

.connect:
    mov     edi, eax
    push    dword 0x4227a28b    ; push 139.162.39.66 onto stack IP ADDRESS
    push    word 0x5000         ; push 80 onto stack PORT
    push    word 2   ; AF_INET
    mov     ecx, esp
    push    16
    push    ecx
    push    edi
    mov     ecx, esp
    mov     ebx, 3      ; subroutine CONNECT
    mov     eax, 102
    int     80h

.write:
    mov     edx, request.length
    mov     ecx, request
    mov     ebx, edi
    mov     eax, 4
    int     80h

.read:
    mov     edx, 4096
    mov     ecx, buffer
    mov     ebx, edi
    mov     eax, 3
    int     80h

    cmp     eax, 0
    jz      .close
    mov     eax, buffer
    call    sprint
    jmp     .read

.close:
    mov     ebx, edi
    mov     eax, 6      ; SYS_CLOSE kernel opcode 6
    int     80h

    call    quitProgram
