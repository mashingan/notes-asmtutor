format ELF64 executable 3
entry start

include 'procs.inc'

segment readable
msg db  'Seconds since 1 January 1970: ', 0h

segment readable executable
start:
    mov     rax, msg
    call    sprint

    mov     rdi, 0
    mov     rax, 201 ; SYS_TIME (kernel opcode 201)
    syscall

    call    iprintLF
    call    quitProgram
