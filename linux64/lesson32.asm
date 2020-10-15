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

    mov     rcx, rsp
    push    0           ; sockaddr_in.sin_zero
    push    0           ; sockadr_in.sin_addr
    push    word 0x2923 ; sockaddr_in.sin_port
    push    word 2      ; sockaddr_in.sa_family
    mov     rdx, rsp
    sub     rcx, rdx    ;
    mov     rdx, rcx    ; sockaddr_in length

    mov     rax, rdx
    call    iprintLF

    mov     rsi, rsp    ; move the pointer from struct sockaddr /
                        ; sockaddr_in on stack
    mov     rax, 49     ; SYS_BIND kernel opcode 49
    syscall

.listen:
    mov     rsi, 1  ; backlog?
    mov     rax, 50 ; SYS_LISTEN kernel opcode 50
    syscall

.accept:
    push    0   ; addrlen argument
    push    0   ; addr argument
    xorc    rdx         ; int *upeer_addrlen
    mov     rsi, rsp    ; struct sockaddr *upeer_sockaddr
    mov     rax, 43     ; SYS_ACCEPT kernel opcode
    syscall

    call    quitProgram
