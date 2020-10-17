format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?
banner  db  'Count and print each line to 10', 0

section '.text' code readable executable

start:
    fastcall setStdout
    mov     rcx, banner
    fastcall sprintLF
    mov     r12, 0
@@:
    inc     r12
    cmp     r12, 10
    jg      @f
    mov     rax, r12
    add     rax, '0'
    push    rax
    mov     rcx, rsp
    fastcall sprintLF
    pop     rax
    jmp     @b
@@:
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
