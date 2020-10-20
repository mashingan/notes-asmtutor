org 256

start:
    mov     dx, msg
    call    sprintCRLF
    mov     dx, msgf
    call    sprintCRLF
    int     20h

include 'procs.inc'

msg     db  'Hello the brave to the isekai!', 0
msgf    db  'Adapt to the new environment with FASM.', 0
