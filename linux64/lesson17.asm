format ELF64 executable 3
entry start

include 'procs.inc'

segment readable
finmsg  db  'Jumping to finished label.', 0h
subnum  db  'Inside subroutine number: ', 0h
subfin  db  'Inside subroutine "finished."', 0h

segment readable writable
start:
subroutineOne:
    mov     rax, finmsg
    call    sprintLF
    jmp     .finished
.finished:
    mov     rax, subnum
    call    sprint
    mov     rax, 1
    call    iprintLF

subroutineTwo:
    mov     rax, finmsg
    call    sprintLF
    jmp     .finished
.finished:
    mov     rax, subnum
    call    sprint
    mov     rax, 2
    call    iprintLF

    mov     rax, finmsg
    call    sprintLF
    jmp     finished

finished:
    mov     rax, subfin
    call    sprintLF
    call    quitProgram
