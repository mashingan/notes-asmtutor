org 256

start:
    mov     dx, msg
    call    sprint
    mov     dx, msgf
    call    sprint
    int 20h

include 'procs.inc'

msg     db  'Hello the brave to the isekai!', 0dh, 0Ah, 0, 0
msgf    db  'Adapt to the new environment with FASM.', 0dh, 0Ah, 0, 0
