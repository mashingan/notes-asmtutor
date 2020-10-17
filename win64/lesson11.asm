format PE64 console
entry start

include 'win64w.inc'
include 'macros.inc'

section '.data' data readable writeable
stdout  dq  ?

section '.text' code readable executable

start:
    fastcall setStdout
    mov     r12, 0
@@:
    inc     r12
    mov     rcx, r12
    fastcall iprintLF
    cmp     r12, 10
    jne     @b
@@:
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
