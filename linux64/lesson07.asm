format ELF64 executable 3
entry start

segment readable writeable

msg     db  'Hello the brave to the isekai!', 0h
msgf    db  'Adapt to the new environment with FASM.', 0h

segment readable executable

start:
mov     rax, msg
call    sprintLF

mov     rax, msgf
call    sprintLF

call    quitProgram

include 'procs.inc'
