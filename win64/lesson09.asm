;; support for unicode input
; try input it as: Est 魔聖剣
format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  rq 1
stdin   rq 1
prompt  db  'Please enter your name: ', 0h
hello   db  'Hello, ', 0h

sinsize = 255
sinput  rw  sinsize

section '.text' code readable executable

start:
    fastcall setStdout
    mov     rcx, stdin
    fastcall setStdin
    mov     rcx, prompt
    fastcall sprint
    push    0
    mov     r12, rsp
    invoke  ReadConsole, [stdin], sinput, sinsize, r12, 0
    cmp     rax, 0
    je      .quit

    mov     rcx, hello
    fastcall sprint

    mov     rdx, [r12]
    mov     rcx, sinput
    fastcall snprintW
    pop     rax ; discard the readbyte

.quit:
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
