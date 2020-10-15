format ELF64 executable 3
entry start

include 'procs.inc'

segment readable
filename    db  'filecreate.txt', 0h
content     db  'hello world!', 0h
content.length = $ - content

segment readable executable
start:
    mov     rsi, 0777
    mov     rdi, filename
    mov     rax, 85
    syscall

    mov     rdx, content.length
    mov     rsi, content
    mov     rdi, rax
    mov     rax, 1
    syscall

    call    quitProgram
