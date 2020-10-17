format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq ?

section '.text' code readable executable

start:
    fastcall setStdout
    invoke  GetCommandLineA
    mov     rcx, rax
    fastcall sprintLF
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
