format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?
filename    TCHAR  'filecreate.txt', 0h
failc   db  'failed code: ', 0h
writes  db  'read file success', 0h
content rw  32
contlen = $ - content

section '.text' code readable executable

start:
    fastcall setStdout

    enter   16, 0
    lea     r15, [rbp-8]
    invoke  CreateFile, filename,\
            GENERIC_READ,\
            0,\
            0,\
            OPEN_ALWAYS,\
            FILE_ATTRIBUTE_NORMAL,\
            0
    mov     [r15], rax
    cmp     rax, 0
    jne     @f
    jmp     .err
@@:
    lea     r14, [rbp-16]
    mov     rdi, [r15]
    invoke  ReadFile, rdi, content, contlen, r14, 0
    cmp     rax, false
    jne     @f
    jmp     .err
@@:
    mov     rcx, [r14]
    fastcall iprintLF
    mov     rdx, [r14]
    mov     rcx, content
    fastcall snprint
.leave:
    leave
    fastcall quitProgram

.err:
    invoke  GetLastError
    mov     r13, rax
    mov     rcx, failc
    fastcall sprint
    mov     rcx, r13
    fastcall iprintLF
    jmp     .leave

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
