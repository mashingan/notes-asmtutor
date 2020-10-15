format ELF64 executable 3
entry start

include 'procs.inc'

segment readable writable
banner  db  '90 div 9', 0Ah, 0
msgrem  db ' remainder ', 0

segment readable executable
start:
    mov     rax, banner
    call    sprint
    mov     eax, 90
    mov     ebx, 9
    div     ebx
    call    iprint
    mov     rax, msgrem
    call    sprint
    mov     eax, edx
    call    iprintLF
    call    quitProgram
