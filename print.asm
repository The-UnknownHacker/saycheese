%ifndef PRINT_ASM
%define PRINT_ASM

%include "syscall.asm"

section .data
    DEF_STR newline, 10

section .text

global print

print:
    mov rdi, 1     ; STDOUT_FILENO
    call write
    ret

global println

println:
    call print            ; print original string
    mov rsi, newline
    mov rdx, newline_len
    call print            ; print newline
    ret

%endif
