format ELF64 executable 3
entry start

include 'procs.inc'

segment readable writable
buffer  rb  4096

segment readable
request db 'GET / HTTP/1.1', 0dh, 0ah, 'Host: 139.162.39.66:80'

rept 2 {
    db  0dh, 0ah
}
    db 0h
request.length = $ - request

struc sockaddr_in family, port, addr, last {
    .family  dw  family
    .port    dw  port
    .addr    dq  addr
    .last    dq  last
}

sock    sockaddr_in 2, 0x5000, 0x4227a28b, 0
socklen = $ - sock

segment readable executable
start:
    xorc    rax
    xorc    rdx
    xorc    rdi
    xorc    rsi
    xorc    rbx

.socket:
    mov     rdx, 6  ; IPPROTO_TCP
    mov     rsi, 1  ; SOCK_STREAM
    mov     rdi, 2  ; PF_INET
    mov     rax, 41 ; SYS_SOCKET
    syscall

    mov     rdi, rax

.connect:
    ;mov     rdx, rsp
    ;push    0
    ;push    0x4227a28b    ; push 139.162.39.66 onto stack IP ADDRESS
    ;push    word 0x5000         ; push 80 onto stack PORT
    ;push    word 2   ; AF_INET
    ;mov     rsi, rsp
    ;sub     rdx, rsi

    mov     rsi, sock
    mov     rdx, socklen

    mov     rax, 42     ; SYS_CONNECT
    syscall

.write:
    mov     rdx, request.length
    mov     rsi, request
    mov     rax, 1
    syscall

.read:
    mov     rdx, 4096
    mov     rsi, buffer
    mov     rax, 0
    syscall

    cmp     rax, 0
    jz      .close
    mov     rbx, rax
    mov     rax, buffer
    call    snprint
    jmp     .read

.close:
    mov     rax, 3      ; SYS_CLOSE kernel opcode 3
    syscall

    call    quitProgram
