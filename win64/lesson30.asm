format PE64 console

include 'win64wx.inc'
include 'equates\wsock32.inc'
INVALID_SOCKET = -1

.data
stdout  dq  ?
failc   db  'failed code: ', 0h

socksize = 8
.code
main:
    fastcall setStdout
    enter   sizeof.WSADATA+socksize+sizeof.sockaddr_in, 0
    and     rsp, -16    ; make it 16-bite aligned
    mov     rcx, sizeof.WSADATA+socksize+sizeof.sockaddr_in
    fastcall iprintLF
    xor     rbx, rbx
    mov     bl, 2   ; major version
    mov     bh, 2   ; minor version
    lea     r15, [rbp-sizeof.WSADATA]
    invoke  WSAStartup, rbx, r15
    push    rax
    pop     rax
    cmp     rax, 0
    jne     .wsaerr
.socket:
    lea     r14, [rbp-sizeof.WSADATA-socksize]
    invoke  socket, 2, 1, 6
    mov     [r14], rax
    cmp     rax, INVALID_SOCKET
    je      .err
    mov     rcx, rax
    fastcall iprintLF
.bind:
    lea     r13, [rbp-sizeof.WSADATA-socksize-sizeof.sockaddr_in]
    mov     word [r13+sockaddr_in.sin_family], AF_INET
    mov     word [r13+sockaddr_in.sin_port], 0x2923
    mov     rdi, [r14]
    invoke  bind, rdi, r13, sizeof.sockaddr_in
    cmp     rax, 0
    jne     .err
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
