;; connect with telnet to
;; telnet localhost 9001
;; to accept the connection and close our program
format PE64 console

include 'win64wx.inc'
include 'equates\wsock32.inc'
INVALID_SOCKET = -1

.data
stdout  dq  ?
failc   db  'failed code: ', 0h
closes  db  'closing socket', 0h

socksize = 8
SOMAXCONN = 0

virtual at rbp-sizeof.WSADATA
    wsaptr  dq  ?
end virtual

virtual at rbp-sizeof.WSADATA-socksize
    listenSockptr dq ?
end virtual

virtual at rbp-sizeof.WSADATA-socksize-sizeof.sockaddr_in
    saptr dq ?
end virtual

totalalloc = sizeof.WSADATA+2*socksize+sizeof.sockaddr_in

virtual at rbp-totalalloc
    accsockPtr dq ?
end virtual

virtual at rbp-totalalloc-8
    addrlen dq ?
end virtual

.code
main:
    fastcall setStdout
    enter   totalalloc+8, 0
    and     rsp, -16    ; make it 16-bite aligned
    mov     rcx, totalalloc+8
    fastcall iprintLF
    xor     rbx, rbx
    mov     bl, 2   ; major version
    mov     bh, 2   ; minor version
    lea     r15, [wsaptr]
    invoke  WSAStartup, rbx, r15
    push    rax
    pop     rax
    cmp     rax, 0
    jne     .wsaerr
.socket:
    lea     r14, [listenSockptr]
    invoke  socket, 2, 1, 6
    mov     [r14], rax
    cmp     rax, INVALID_SOCKET
    je      .err
    mov     rcx, rax
    fastcall iprintLF
.bind:
    lea     r13, [saptr]
    mov     word [r13+sockaddr_in.sin_family], AF_INET
    mov     word [r13+sockaddr_in.sin_port], 0x2923
    mov     rdi, [r14]
    invoke  bind, rdi, r13, sizeof.sockaddr_in
    cmp     rax, 0
    jne     .err
    mov     rcx, rax
    fastcall iprintLF
.listen:
    invoke  listen, rdi, SOMAXCONN
    cmp     rax, 0
    jne     .err
    mov     rcx, rax
    fastcall iprintLF
.accept:
    lea     r15, [accsockPtr]
    ;lea     rsi, [addrlen]
    ;invoke  accept, rdi, r13, rsi
    invoke  accept, rdi, r13, 0
    mov     [r15], rax
    cmp     rax, INVALID_SOCKET
    je      .err
    mov     rcx, rax
    fastcall iprintLF
.close:
    mov     rax, [r15]
    invoke  closesocket, rax
    cmp     rax, 0
    jne     .err
    invoke  closesocket, rdi
    cmp     rax, 0
    jne     .err
    mov     rcx, closes
    fastcall sprintLF
.quit:
    invoke  WSACleanup
    leave
    fastcall quitProgram
.err:
    invoke  WSAGetLastError
.wsaerr:
    mov     r12, rax
    mov     rcx, failc
    fastcall sprint
    mov     rcx, r12
    fastcall iprintLF
    jmp     .quit

include 'procs.inc'

.end main
