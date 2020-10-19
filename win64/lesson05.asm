format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
msg     db  'Hello the brave to the isekai!', 0dh, 0Ah, 0
msgf    db  'Adapt to the new environment with FASM.', 0dh, 0Ah, 0
stdout  dq ?

section '.text' code readable executable

start:
    fastcall setStdout
    mov     rcx, msg
    fastcall sprint
    
    mov     rcx, msgf
    fastcall sprint
    fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
