;; hit with
;; curl localhost:9001
format PE64 console

include 'win64wx.inc'
include 'equates\wsock32.inc'
INVALID_SOCKET = -1

.data
stdout  dq  ?
failc   db  'failed code: ', 0h
failw   db  'failed sending request', 0h
closes  db  'closing socket', 0h
buflen = 4096
buffer  rb  buflen

request db 'GET / HTTP/1.1', 0dh, 0ah, 'Host: 139.162.39.66:80'

rept 2 {
    db  0dh, 0ah
}
    db 0h
request.length = $ - request

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
    connsockPtr dq ?
end virtual

totalalloc = sizeof.WSADATA+socksize+sizeof.sockaddr_in
virtual at rbp-totalalloc
    saptr dq ?
end virtual

.code
main:
    fastcall setStdout
    enter   totalalloc, 0
    and     rsp, -16    ; make it 16-bite aligned
    mov     rcx, totalalloc
    fastcall iprintLF
    xor     rbx, rbx
    mov     bl, 2   ; major version
    mov     bh, 2   ; minor version
    lea     r15, [wsaptr]
    invoke  WSAStartup, rbx, r15
    cmp     rax, 0
    jne     .wsaerr
.socket:
    lea     r14, [connsockPtr]
    invoke  socket, 2, 1, 6
    mov     [r14], rax
    cmp     rax, INVALID_SOCKET
    je      .err
.connect:
    lea     r13, [saptr]
    mov     word [r13+sockaddr_in.sin_family], 2
    mov     word [r13+sockaddr_in.sin_port], 0x5000
    mov     dword [r13+sockaddr_in.sin_addr], 0x4227a28b
    invoke  connect, rax, r13, sizeof.sockaddr_in
    cmp     rax, 0
    jne     .err
.request:
    mov     rax, [r14]
    mov     rdi, rax
    invoke  send, rdi, request, request.length, MSG_DONTROUTE;+MSG_OOB
    cmp     rax, 0
    jge     .read
    mov rcx, failw
    fastcall sprintLF
    jmp .err
.read:
    ;invoke  recv, rdi, buffer, buflen, MSG_PEEK
    invoke  recv, rdi, buffer, buflen, 0 ; recv until peer closes conn
    cmp     rax, 0
    jle     .close
    mov     rcx, buffer
    mov     rdx, rax
    fastcall snprintLF
    jmp     .read
.close:
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
