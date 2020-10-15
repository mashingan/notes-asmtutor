format ELF64 executable 3
entry start

include 'procs.inc'

segment readable executable
start:
    xorc    rax
    xorc    rdx
    xorc    rdi
    xorc    rsi

.socket:
    mov     rdx, 6  ; IPPROTO_TCP
    mov     rsi, 1  ; SOCK_STREAM
    mov     rdi, 2  ; PF_INET
    mov     rax, 41 ; SYS_SOCKET
    syscall

.bind:
    mov     rdi, rax    ; SOCKET FD
    mov     rdx, 0      ; IP_ADDRESS 0.0.0.0
    push    word 0x2923 ; struct sockaddr.sa_data
    push    word 2      ; struct sockaddr.sa_family
    mov     rsi, rsp    ; move the pointer from struct sockaddr on stack
    mov     rax, 49     ; SYS_BIND kernel opcode 49
    syscall

    call    quitProgram
