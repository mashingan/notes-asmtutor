;; hit with
;; curl localhost:9001
format PE64 console

include 'win64wx.inc'
include 'equates\wsock32.inc'
INVALID_SOCKET = -1

.data
stdout  dq  ?
failc   db  'failed code: ', 0h
failw   db  'failed to write', 0h
closes  db  'closing socket', 0h
buffer  rb  255

response db 'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html'
         db 0Dh, 0Ah, 'Content-Length: 14'
rept 2 {
    db  0Dh, 0Ah
}
        db 'Hello world!', 0Dh, 0Ah, 0h
response.length = $ - response

socksize = 8
SOMAXCONN = 1

MSG_OOB = 0x1
MSG_PEEK = 0x2
MSG_DONTROUTE = 0x4
MSG_EOR = 0x8
MSG_TRUNC = 0x10
MSG_CTRUNC = 0x20
MSG_WAITALL = 0x40

SD_RECEIVE = 0
SD_SEND = 1
SD_BOTH = 2

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

dummylen = totalalloc-8
virtual at rbp-dummylen
    addrlen dq ?
end virtual

dummySockaddr = dummylen+sizeof.sockaddr_in
virtual at rbp-dummySockaddr
    dummySaPtr dq ?
end virtual

.code
main:
    fastcall setStdout
    enter   dummySockaddr, 0
    and     rsp, -16    ; make it 16-bite aligned
    mov     rcx, dummySockaddr
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
.bind:
    lea     r13, [saptr]
    mov     word [r13+sockaddr_in.sin_family], AF_INET
    mov     word [r13+sockaddr_in.sin_port], 0x2923
    mov     rdi, [r14]
    invoke  bind, rdi, r13, sizeof.sockaddr_in
    cmp     rax, 0
    jne     .err
.listen:
    invoke  listen, rdi, SOMAXCONN
    cmp     rax, 0
    jne     .err
.accept:
    lea     r15, [accsockPtr]
    lea     rsi, [addrlen]
    mov     qword [rsi], sizeof.sockaddr_in
    lea     r13, [dummySaPtr]
    invoke  accept, rdi, r13, rsi
    mov     [r15], rax
    cmp     rax, INVALID_SOCKET
    jle     .err
.read:
    mov     rax, [r15]
    invoke  recv, rax, buffer, 255, MSG_PEEK
    cmp     rax, 0
    jl      .err
    mov     rcx, buffer
    fastcall sprintLF
.write:
    mov     rax, [r15]
    invoke  send, rax, response, response.length, MSG_DONTROUTE;+MSG_OOB
    ;cmp     rax, 0
    ;jl      @f
    .if rax < 0
        jl  @f
    .else
        ;; to wait the socket send the response
        mov rcx, rax
        fastcall iprintLF
        jmp .close
    .endif
    ;jmp     .close
@@:
    push    rax
    mov     rcx, failw
    fastcall sprintLF
    pop     rax
.close:
    invoke  closesocket, rdi
    cmp     rax, 0
    jne     .err
    mov     rax, [r15]
    invoke  closesocket, rax
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
