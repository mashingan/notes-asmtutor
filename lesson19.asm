format ELF executable 3
entry start

include 'procs.inc'

segment readable
command db  '/bin/echo', 0h
arg1    db  'Hello world!', 0h
args    dd  command
        dd  arg1    ; argument to pass to command line
        dd  0h      ; end of struct

env     dd  0h      ; arguments to pass as environment variable
                    ; since this is none, so end of struct

segment readable executable
start:
    mov     edx, env
    mov     ecx, args
    mov     ebx, command
    mov     eax, 11
    int     80h

    call    quitProgram
