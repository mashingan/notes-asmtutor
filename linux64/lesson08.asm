; Don't use rbx (as return address) and r11 (as flags ret)
; because those two not guarantee to intact after syscall
; ref: https://stackoverflow.com/a/50571366
format ELF64 executable 3
entry start

include 'procs.inc'

segment readable executable
start:
    pop     rbx
@@:
    cmp     rbx, 0h
    jz      @f
    pop     rax
    call    sprintLF
    dec     rbx
    jmp     @b
@@:
    call    quitProgram
