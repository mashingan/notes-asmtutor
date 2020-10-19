format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?
command db  'c:\windows\system32\cmd.exe', 0h
arg1    db  '/C "echo Hello isekai!"', 0h

startupinfo STARTUPINFO
pi  PROCESS_INFORMATION

section '.text' code readable executable
start:
    fastcall setStdout

    push    qword 0
    mov     r15, rsp
    mov     rcx, rsp
    fastcall setStdin
    mov     rcx, sizeof.STARTUPINFO
    mov     rdi, startupinfo
    mov     al, 0
    rep stosb
    mov     rcx, sizeof.PROCESS_INFORMATION
    mov     rdi, pi
    mov     al, 0
    rep stosb
    mov     rdi, startupinfo
    mov     rsi, pi
    mov     [rdi+STARTUPINFO.cb], sizeof.STARTUPINFO
    mov     rax, [stdout]
    mov     [rdi+STARTUPINFO.hStdOutput], rax
    mov     rax, [r15]
    mov     [rdi+STARTUPINFO.hStdInput], rax
    invoke CreateProcessA, command, arg1, 0, 0, true, 0, 0, 0, rdi, rsi
    pop     rax ; discard stdin
.leave:
    fastcall quitProgram

    ; historical attempt to use local variable with enter/leave
    ;enter   sizeof.STARTUPINFO+sizeof.PROCESS_INFORMATION, 0
    ;lea     r15, [stdin]
    ;mov     rcx, r15
    ;fastcall setStdin
    ;mov     rcx, r15
    ;fastcall iprintLF
    ;mov     dword [rbp-STARTUPINFO.cb], sizeof.STARTUPINFO
    ;mov     [rbp-STARTUPINFO.hStdInput], r15
    ;mov     rax, [stdout]
    ;mov     [rbp-STARTUPINFO.hStdOutput], rax
    ;mov     rdi, rbp
    ;lea     rsi, [rsp+sizeof.PROCESS_INFORMATION]
    ;invoke CreateProcessA, command, arg1, 0, 0, true, 0, 0, 0, rdi, rsi
    ;leave
    ;fastcall quitProgram

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
