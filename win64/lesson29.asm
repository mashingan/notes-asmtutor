format PE64 console

include 'win64wx.inc'
include 'equates\wsock32.inc'
INVALID_SOCKET = -1

.data
stdout  dq  ?
failc   db  'failed code: ', 0h

.code
main:
    fastcall setStdout
    ;; the additional 8 is needed to align the 16-bit boundary
    ;; with the 8 bit of ret address already pushed and the size of
    ;; WSADATA is 400, so without +8 it will 408 which 408/16=25.5 (not aligned)
    ;; so add with +8 to be 416/16=26
    ;enter   sizeof.WSADATA+8, 0
    enter   sizeof.WSADATA, 0
    and     rsp, -16    ; make it 16-bite aligned
    mov     rcx, sizeof.WSADATA
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
    invoke  socket, 2, 1, 6
    cmp     rax, INVALID_SOCKET
    je      .err
    mov     rcx, rax
    fastcall iprintLF
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
