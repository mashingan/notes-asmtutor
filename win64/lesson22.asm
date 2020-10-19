format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?
filename    TCHAR  'filecreate.txt', 0h
fail    db  'failed to create file', 0h

section '.text' code readable executable

start:
    fastcall setStdout

    invoke  CreateFile, filename,\
            GENERIC_READ|GENERIC_WRITE,\
            0,\
            0,\
            OPEN_ALWAYS,\
            FILE_ATTRIBUTE_NORMAL,\
            0
    cmp     rax, 0
    jne     @f
    mov     rcx, fail
    fastcall sprintLF
@@:

    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
