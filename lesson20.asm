format ELF executable 3
entry start

include 'procs.inc'

segment readable
childMsg    db  'This is the child process', 0h
parentMsg   db  'This is the parent process', 0h

segment readable executable
start:
    mov     eax, 2  ; SYS_FORK (kernel opcode 2)
    int     80h

    cmp     eax, 0  ; if eax is zero, we are in the child process
    jnz     .parent ; jump to child if eax is zero

.child:
    mov     eax, childMsg
    call    sprintLF
    call    quitProgram

.parent:
    mov     eax, parentMsg
    call    sprintLF
    call    quitProgram
