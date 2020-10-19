format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?
finmsg  db  'Jumping to finished label.', 0h
subnum  db  'Inside subroutine number: ', 0h
subfin  db  'Inside subroutine "finished."', 0h

section '.text' code readable executable
start:
    fastcall setStdout
subroutineOne:
    mov     rcx, finmsg
    fastcall sprintLF
    jmp     .finished
.finished:
    mov     rcx, subnum
    fastcall sprint
    mov     rcx, 1
    fastcall iprintLF

subroutineTwo:
    mov     rcx, finmsg
    fastcall sprintLF
    jmp     .finished
.finished:
    mov     rcx, subnum
    fastcall sprint
    mov     rcx, 2
    fastcall iprintLF

    mov     rcx, finmsg
    fastcall sprintLF
    jmp     finished

finished:
    mov     rcx, subfin
    fastcall sprintLF
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
;import kernel32,\
    ;GetStdHandle, 'GetStdHandle',\
    ;WriteConsoleA, 'WriteConsoleA',\
    ;WriteConsoleW, 'WriteConsoleW',\
    ;ExitProcess, 'ExitProcess'
