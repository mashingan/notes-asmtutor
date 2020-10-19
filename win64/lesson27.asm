format PE64 console
entry start

include 'win64w.inc'

macro reachit {
    mov     rcx, reach
    fastcall sprintLF
}

section '.data' data readable writeable
stdout  dq  ?
filename    TCHAR  'filecreate.txt', 0h
failc   db  'failed code: ', 0h
updateEst dd 13, 10, 'エ','ス','ト', ' ', '魔','聖','剣'
estlen = $ - updateEst
content rw  256 ; to use several times
contlen = $ - content
reach   db  'reach here', 0

section '.text' code readable executable

start:
    fastcall setStdout

    enter   16, 0
    mov     r12, 2; read twice
    lea     r15, [rbp-8]
    invoke  CreateFile, filename,\
            GENERIC_WRITE+GENERIC_READ,\
            0,\
            0,\
            OPEN_ALWAYS,\
            FILE_ATTRIBUTE_NORMAL,\
            0
    mov     [r15], rax
    cmp     byte [r15], 0
    jne     @f
    jmp     .err
@@:
.readfile:
    cmp     r12, 0
    je      .writecontent
    lea     r14, [rbp-16]
    mov     rdi, [r15]
    dec     r12
    invoke  ReadFile, rdi, content, contlen, r14, 0
    cmp     rax, false
    jne     @f
    reachit
    jmp     .err
@@:
.appendfile:
    cmp     r12, 0
    je      .writecontent
    invoke  SetFilePointer, rdi, 0, 0, FILE_END
    invoke  WriteFile, rdi, updateEst, estlen, r14, 0
    cmp     rax, 0
    je      .err
    invoke  SetFilePointer, rdi, 0, 0, FILE_BEGIN
    jmp     .readfile
@@:
.writecontent:
    mov     rcx, [r14]
    fastcall iprintLF
    mov     rdx, [r14]
    mov     rcx, content
    fastcall snprint
.closehandle:
    invoke  CloseHandle, rdi
    ;cmp     rax, 0
    ;je      .err
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
    cmp     rdi, 0
    je      .closehandle
    jmp     .leave

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
