format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?
msg db  'Seconds since 1 January 1970: ', 0h

section '.text' code readable executable

start:
    fastcall setStdout
    enter   2*sizeof.FILETIME+2*sizeof.SYSTEMTIME, 0
    lea     r12, [rbp-sizeof.FILETIME]
    lea     r13, [rbp-(2*sizeof.FILETIME)]
    lea     r14, [rbp-(2*sizeof.FILETIME)-sizeof.SYSTEMTIME]
    mov     r15, rsp
    invoke  GetSystemTime, r14
    invoke  SystemTimeToFileTime, r14, r12
    cmp     rax, 0
    je      .leave
    mov     word [r15+SYSTEMTIME.wYear], 1970
    mov     word [r15+SYSTEMTIME.wMonth], 1
    mov     word [r15+SYSTEMTIME.wDay], 1
    invoke  SystemTimeToFileTime, r15, r13
    cmp     rax, 0
    je      .leave
    mov     rax, [r12]
    sub     rax, [r13]
    xor     rdx, rdx
    mov     rdi, 10000
    div     rdi
    push    rax
    mov     rcx, msg
    fastcall sprint
    pop     rcx
    fastcall iprintLF
.leave:
    leave
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
