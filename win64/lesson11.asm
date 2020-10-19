format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?

section '.text' code readable executable

start:
    fastcall setStdout
    mov     rbx, 0
@@:
    inc     rbx
    mov     rcx, rbx
    fastcall iprintLF
    cmp     rbx, 10
    jne     @b
@@:
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
