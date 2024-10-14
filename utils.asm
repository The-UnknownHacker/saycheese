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

    mov rax, rdi
    div byte [dividend]
    mov dil, al
    add ah, "0"
    mov byte [rsi + rcx], ah
    inc rcx

    cmp dil, 0
    jnz ._itoa
.reverse:
    mov byte [rsi + rcx], 0 ; null-terminate string
    
    ; below this is equivalent to strrev() in C's stdlib
    ; (without checking strlen since that's already stored in `rcx`)
    dec rcx                 ; set rcx to strlen - 1
    xor rax, rax            ; set rax to 0
.revloop:
    ; swap the bytes on opposite ends of the string
    mov dil, byte [rsi + rax]
    mov r8b, byte [rsi + rcx] 
    mov byte [rsi + rax], r8b
    mov byte [rsi + rcx], dil

    inc rax
    dec rcx
    cmp rax, rcx
    jl .revloop

    ret

global randint

; generates a random number in the given range (inclusive)
; dil: lower bound
; sil: upper bound
; al: return value
randint:
    ; save the parameters in preserved registers
    push r12
    push r13
    mov r12b, dil
    mov r13b, sil

    ; generate a single random byte in rax
    push qword 0
    mov rdi, rsp
    mov rsi, 1
    xor rdx, rdx
    call getrandom
    pop rax

    ; upper bound - lower bound + 1
    sub r13b, r12b
    inc r13b

    ; (random % range) + lower bound
    div r13b
    mov al, ah
    add r12b, al

    ; store result in the rax register
    xor rax, rax
    mov al, r12b

    ; restore preserved registers
    pop r13
    pop r12

    ret

global set_foreground

; rdi: buffer containing foreground ANSI color
; rsi: buffer length
set_foreground:
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi

    mov rsi, ansi_foreground
    mov rdx, ansi_foreground_len
    call print

    jmp set_ansi

global set_background

set_background:
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi

    mov rsi, ansi_background
    mov rdx, ansi_background_len
    call print

    jmp set_ansi

global reset_color

reset_color:
    mov rsi, ansi_reset
    mov rdx, ansi_reset_len
    call print

    ret

set_ansi:
    mov rsi, r12
    mov rdx, r13
    call print

    mov rsi, ansi_end
    mov rdx, ansi_end_len
    call print

    pop r13
    pop r12
    ret


section .data
    dividend: db 10
    DEF_STR ansi_reset, 27,"[0m"
    DEF_STR ansi_foreground, 27,"[38;5;"
    DEF_STR ansi_background, 27,"[48;5;"
    DEF_STR ansi_end, "m"

%endif
