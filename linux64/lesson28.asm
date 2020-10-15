format ELF64 executable 3
entry start

include 'procs.inc'

segment readable
filename    db  'filecreate.txt', 0h

segment readable executable
start:
    mov     rdi, filename
    mov     rax, 87         ; SYS_UNLINK
    syscall

    call    quitProgram
