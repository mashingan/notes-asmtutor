format ELF executable 3
entry start

include 'procs.inc'

segment readable
finmsg  db  'Jumping to finished label.', 0h
subnum  db  'Inside subroutine number: ', 0h
subfin  db  'Inside subroutine "finished."', 0h

segment readable writable
start:
subroutineOne:
    mov     eax, finmsg
    call    sprintLF
    jmp     .finished
.finished:
    mov     eax, subnum
    call    sprint
    mov     eax, 1
    call    iprintLF

subroutineTwo:
    mov     eax, finmsg
    call    sprintLF
    jmp     .finished
.finished:
    mov     eax, subnum
    call    sprint
    mov     eax, 2
    call    iprintLF

    mov     eax, finmsg
    call    sprintLF
    jmp     finished

finished:
    mov     eax, subfin
    call    sprintLF
    call    quitProgram
