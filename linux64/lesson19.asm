format ELF64 executable 3
entry start

include 'procs.inc'

segment readable
command db  '/bin/echo', 0h
arg1    db  'Hello world!', 0h
args    dq  command
        dq  arg1    ; argument to pass to command line
        dq  0h      ; end of struct

env     dq  0h      ; arguments to pass as environment variable
                    ; since this is none, so end of struct

segment readable executable
start:
    mov     rdx, env
    mov     rsi, args
    mov     rdi, command
    mov     rax, 59
    syscall

    call    quitProgram
