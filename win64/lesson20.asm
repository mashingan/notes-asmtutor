;; Windows doesn't support fork instead we have to use CreateProcess and/or
;; CreateThread, but CreateProcess can only run the external program and
;; cannot run itself within our program. Hence we use CreateThread to emulate
;; the simulatenous execution. However keep mind that the thread result isn't
;; reliable indicator because the RAX register could be possible used and/or
;; changed in separate occasion.
format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?
childMsg    db  'This is the child process', 0h
parentMsg   db  'This is the parent process', 0h
threadfail  db  'Thread was failed', 0h
threadid    dd ?
threadhandle dd ?
threadret   dd ?

section '.text' code readable executable
start:
    fastcall setStdout

    invoke  CreateThread, 0, 0, child, childMsg, 0, threadid
    mov     [threadhandle], eax
    cmp     rax, 0
    je      .quit
    mov     ecx, [threadid]
    fastcall iprintLF
    mov     edi, [threadhandle]
    invoke  WaitForSingleObject, r15, 100; milliseconds
    invoke  GetExitCodeThread, edi, threadret
    cmp     [threadret], 0
    je      .parent
    mov     rcx, threadfail
    fastcall sprintLF

.parent:
    mov     rcx, parentMsg
    fastcall sprintLF
.cleanThread:
    mov     edi, [threadhandle]
    invoke  CloseHandle, edi
.quit:
    fastcall quitProgram

proc child arg
    mov     [arg], rcx
    fastcall sprintLF
    mov     rax, 0
    ret
endp

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
