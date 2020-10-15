format ELF64 executable 3
entry start

include 'procs.inc'

segment readable writable
response db 'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html'
         db 0Dh, 0Ah, 'Content-Length: 14'
rept 2 {
    db  0Dh, 0Ah
}
        db 'Hello world!', 0Dh, 0Ah, 0h
response.length = $ - response
buffer  rb  255

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
    xorc    rdx     ; int *upeer_addrlen, null length
    xorc    rsi     ; struct sockaddr *upeer_sockaddr, ignore data
    mov     rax, 43 ; SYS_ACCEPT kernel opcode
    syscall

.fork:
    mov     rbx, rax
    mov     rax, 57
    syscall
    cmp     rax, 0
    jz      .read
    jmp     .accept

.read:
    mov     rdx, 255
    mov     rsi, buffer
    mov     rdi, rbx    ; fd after accepting
    mov     rax, 0
    syscall

    mov     rax, buffer
    call    sprintLF

.write:
    ;mov     edx, response.length
    ;mov     ecx, response
    ;mov     ebx, esi
    ;mov     eax, 4
    ;int     80h
    mov     edx, response.length
    mov     esi, response
    mov     rax, 1
    syscall

    call    quitProgram
