format ELF executable 3
entry start

segment readable writeable

msg     db  'Hello the brave to the isekai!', 0Ah, 0
msgf    db  'Adapt to the new environment with FASM.', 0Ah, 0

segment readable executable

start:
mov     eax, msg
call    sprint

mov     eax, msgf
call    sprint

call    quitProgram

include 'procs.inc'
