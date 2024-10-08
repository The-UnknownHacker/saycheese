%ifndef SYSCALL_ASM
%define SYSCALL_ASM

%define WRITE 1
%define EXIT  60

%macro DEF_STR 2+
    %1 db %2
    %1_len equ $-%1
%endmacro

section .text

global write

write:
    mov rax, WRITE
    syscall
    ret

%endif
    