format ELF64 executable 3
entry start

include 'procs.inc'

segment readable
filename    db  'filecreate.txt', 0h

segment readable executable
start:
    mov     rsi, 0777   ; set all permission read, write execute
    mov     rdi, filename
    mov     rax, 85     ; SYS_CREAT kernel opcode 85
    syscall

    call    quitProgram
