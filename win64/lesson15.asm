format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?

banner  db  '90 div 9', 0Ah, 0
msgrem  db ' remainder ', 0


section '.text' code readable executable
start:
    fastcall setStdout
    mov     rcx, banner
    fastcall sprint
    mov     rax, 90
    mov     rbx, 9
    div     rbx
    push    rdx
    mov     rcx, rax
    fastcall iprint
    mov     rcx, msgrem
    fastcall sprint
    pop     rdx
    mov     rcx, rdx
    fastcall iprintLF
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
