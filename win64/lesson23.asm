format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?
filename    TCHAR  'filecreate.txt', 0h
failc   db  'failed to create file', 0h
failw   db  'failed to write file: ', 0h
writes  db  'write file success', 0h
bom db  0xff, 0xfe, 0, 0
bomlen = $ - bom
content dw  'H', 'e', 'l', 'l', 'o', ' '
        dd  '異', '世', '界'
;content db  'Hello isekai', 0h
contlen = $ - content

section '.text' code readable executable

start:
    fastcall setStdout

    enter   24, 0
    lea     r15, [rbp-8]
    invoke  CreateFile, filename,\
            GENERIC_WRITE,\
            0,\
            0,\
            OPEN_ALWAYS,\
            FILE_ATTRIBUTE_NORMAL,\
            0
    mov     [r15], rax
    cmp     rax, 0
    jne     @f
    mov     rcx, failc
    fastcall sprintLF
    jmp     .leave
@@:
    invoke  GetLastError
    mov     r13, rax
    lea     r14, [rbp-16]
    mov     rdi, [r15]
    ;invoke  WriteFile, rdi, bom, bomlen, r14, 0
    invoke  WriteFile, rdi, content, contlen, r14, 0
    cmp     rax, false
    jne     @f
    mov     rcx, failw
    fastcall sprint
    mov     rcx, r13
    fastcall iprintLF
    jmp     .leave
@@:
    mov     rcx, writes
    fastcall sprintLF
.leave:
    leave
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
