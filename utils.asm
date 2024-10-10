%ifndef UTILS_ASM
%define UTILS_ASM

%include "syscall.asm"
%include "terminal.asm"

section .text

global rand

rand:
    ret

global itoa

; rdi: value
; rsi: buffer pointer
itoa:
    xor rcx, rcx
._itoa:
    cmp rdi, 0
    jz .reverse

    mov rax, rdi
    mov r11b, 10
    div byte [dividend]
    mov dil, al
    add ah, "0"
    mov byte [rsi + rcx], ah
    inc rcx

    jmp ._itoa
.reverse:
    mov byte [rsi + rcx], 0 ; null-terminate string
    dec rcx             ; set rcx to strlen - 1
    xor rax, rax            ; set rax to 0
.revloop:
    mov dil, byte [rsi + rax]
    mov r8b, byte [rsi + rcx] 
    mov byte [rsi + rax], r8b
    mov byte [rsi + rcx], dil

    inc rax
    dec rcx
    cmp rax, rcx
    jl .revloop

    ret

section .data
    dividend: db 10
    DEF_STR dbg1, "dbg: 1"

%endif
