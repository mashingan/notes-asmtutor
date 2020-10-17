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
readbyte rq 1

section '.text' code readable executable

start:
    fastcall setStdout
    mov     rcx, stdin
    fastcall setStdin
    mov     rcx, prompt
    fastcall sprint
    invoke  ReadConsole, [stdin], sinput, sinsize, readbyte, 0
    cmp     rax, 0
    je      .quit

    mov     rcx, hello
    fastcall sprint

    mov     rdx, [readbyte]
    mov     rcx, sinput
    fastcall snprintW

.quit:
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
