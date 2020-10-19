;; different with Linux which saves each argv in stack, windows save all
;; of its command line arguments as local allocated memory so we have to
;; parse each of its token manually.
format PE64 console
entry start

include 'win64w.inc'

section '.data' data readable writeable
stdout  dq  ?
argptr  dq  ?
banner  db '<lesson16> <arg1> <arg2> ...:', 0Ah, 0
anum    dq  ?
localAllocFail db 'LocalAlloc fail', 0dh, 0ah, 0

buffer = 16

section '.text' code readable executable
start:
    fastcall setStdout
    mov     rcx, banner
    fastcall sprint
    invoke  GetCommandLineA
    mov     [argptr], rax
    invoke  LocalAlloc, LPTR, buffer
    cmp     rax, 0
    je      .failedLocalAlloc
    mov     [anum], rax
    mov     rcx, [argptr]
    mov     rdx, rax
    fastcall parseCmdToken
    mov     rcx, rax
    fastcall iprintLF

    invoke  LocalFree, [argptr]
    invoke  LocalFree, [anum]

    jmp     .quit
.failedLocalAlloc:
    mov     rcx, localAllocFail
    fastcall sprintLF
.quit:
    fastcall quitProgram

proc sep4
    push    rbx
    mov     rbx, 2
@@:
    cmp     rbx, 0
    je      @f
    dec     rbx
    mov     al, '-'
    mov     ah, '-'
    mov     rdx, 2
    push    ax
    mov     rcx, rsp
    fastcall snprint
    pop     ax
    jmp     @b
@@:
    mov     al, 0ah
    mov     ah, 0dh
    push    ax
    mov     rcx, rsp
    mov     rdx, 2
    fastcall snprint
    pop     ax
    pop     rbx
    ret
endp

;; the input would be for example
;; exec.exe 10 30 40 55
;; the first process is discarding first token hence
;;  (1) inc source until ' ' 
;;  (discardSpace) inc source until not ' '
;;  (getAnum) copy source to dest until ' '
;;  (next) move back dest to before its increased, atoi it and add with r13
;;  jmp to 1
proc parseCmdToken
    push    rbx rdi rsi r12
    xor     rbx, rbx
    xor     r12, r12
    xor     rax, rax
    mov     rdi, rdx
    mov     rsi, rcx
.discardFirstArg:
    inc     rsi
    cmp     byte [rsi], 0
    je      .exitParse
    cmp     byte[rsi], ' '
    jne      .discardFirstArg
.discardSpace1:
    inc     rsi
    cmp     byte [rsi], 0
    je      .exitParse
    cmp     byte [rsi], ' '
    je      .discardSpace1
.getANum:
    cmp     byte [rsi], 0
    je      .next
    cmp     byte [rsi], ' '
    je      .next
    inc     rbx
    movsb
    jmp     .getANum
.next:
    sub     rdi, rbx
    mov     rcx, rdi
    fastcall atoi
    add     r12, rax
    ;mov     rcx, rax
    ;fastcall iprintLF
    ;mov     rcx, r12
    ;fastcall iprintLF
    ;fastcall sep4
    xor     rbx, rbx
    jmp     .discardSpace1
.exitParse:
    mov     rax, r12
    pop     r12 rsi rdi rbx
    ret
endp

include 'procs.inc'

section '.idata' import data readable
library kernel32, 'kernel32.dll'

include 'api\kernel32.inc'
