%include "syscall.asm"
%include "terminal.asm"
%include "utils.asm"

global _start

section .text

_start:
    mov rdi, bg_color
    mov rsi, bg_color_len
    call set_background

    call unbuffer         ; unbuffer stdin
poll_loop:
    call getchar
    cmp rax, 0                ; check if the character is `EOF`
    je poll_loop            ; try again if `EOF`

    push r12                    ; r12 is a "preserved" register, so we have to save the contents
    mov r12, rax

    push qword 0            ; make space on the stack for the character
    mov rdi, r12            ; itoa(value: r12,
    mov rsi, rsp            ;            buffer: rsp
    call itoa                 ; );

    mov rsi, rsp
    mov rdx, 3
    call println
    add rsp, 8

    cmp r12, 10
    je finish

    pop r12                     ; retstore the saved contents of r12 
    jmp poll_loop
finish:
    call reset_color

    mov rsi, hello_world
    mov rdx, hello_world_len
    call println

    push r12
    xor r12, r12

.randloop:

    ; generate random number in range 0-15
    mov dil, 0
    mov sil, 15
    call randint

    sub rsp, 8
    mov rdi, rax
    mov rsi, rsp
    call itoa

    mov rsi, rsp
    mov rdx, 8
    call println
    add rsp, 8

    inc r12
    cmp r12, 20
    jl .randloop

    pop r12
    call restore_buffer
    mov rdi, 0
    jmp exit

draw_board:
    push r12
    push r13
    push r14

    xor r12, r12
.row_loop:
    xor r13, r13
.line_loop:
    xor r14, r14



    inc r13
    cmp r13, 5
    jl .box_loop

    inc r12
    cmp r12, 4
    jl .row_loop

    pop r14
    pop r13
    pop r12
    ret

; rdi: box value
set_box_color:
    push r12
    mov r12, rdi



    pop r12
    ret


section .data
    
    DEF_STR bg_color, "238"
    DEF_STR hello_world, "Hello world!"

    DEF_STR box, "█"

    board: dw 0, 0, 0, 0, \
              0, 0, 0, 0, \
              0, 0, 0, 0, \
              0, 0, 0, 0

    DEF_STR color_2, ""
    