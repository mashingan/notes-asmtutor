format ELF64 executable 3
entry start

include 'procs.inc'

segment readable
childMsg    db  'This is the child process', 0h
parentMsg   db  'This is the parent process', 0h

segment readable executable
start:
    mov     rax, 57  ; SYS_FORK (kernel opcode 57)
    syscall

    cmp     rax, 0  ; if eax is zero, we are in the child process
    jnz     .parent ; jump to child if eax is zero

.child:
    mov     rax, childMsg
    call    sprintLF
    call    quitProgram

.parent:
    mov     rax, parentMsg
    call    sprintLF
    call    quitProgram
