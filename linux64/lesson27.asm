format ELF64 executable 3
entry start

include 'procs.inc'

segment readable
filename    db  'filecreate.txt', 0h
newcontents db  0Ah, '-updated-', 0h
newcon.len  = $ - newcontents
opened  db  'file opened', 0ah, 0h
written db  'file written', 0ah, 0h
sought  db  'sought: ', 0h
currpos db  'currpos: ', 0h

segment readable executable
start:
    mov     rdx, O_WRONLY
    ;or      rdx, O_APPEND
    mov     rsi, O_WRONLY
    ;or      rsi, O_APPEND
    ;or      rsi, O_CREAT
    mov     rdi, filename
    mov     rax, 2          ; SYS_OPEN
    syscall
    cmp     rax, -1
    je      .exit
    mov     rdi, rax
    mov     rax, opened
    call    sprint

    mov     rdx, 0
    xorc    rsi
    mov     rax, 8
    syscall
    mov     rbx, rax
    mov     rax, currpos
    call    sprint
    mov     rax, rbx
    call    iprintLF

    mov     rdx, 2
    xorc    rsi
    mov     rax, 8 ; SYS_LSEEK
    syscall
    cmp     rax, -1
    je      .exit
    mov     rbx, rax
    mov     rax, sought
    call    sprint
    mov     rax, rbx
    call    iprintLF


    mov     rdx, newcon.len
    mov     rsi, newcontents
    mov     rdi, rdi
    mov     rax, 1
    syscall
    mov     rax, written
    call    sprint

.exit:
    call    quitProgram
