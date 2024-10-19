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

.randloop: ; generate random number in range 0-15
    mov dil, 0
    mov sil, 15
    call randint

    sub rsp, 8
    mov rdi, rax
    mov rsi, rsp
    call itoa

    mov rsi, rsp
    mov rdx, rax
    call println
    add rsp, 8

    inc r12
    cmp r12, 20
    jl .randloop

    call clear_term
    call draw_board

    call clear_term
    call draw_board

    pop r12
    call restore_buffer
    mov rdi, 0

    jmp exit

draw_board:
    push r12
    push r13
    push r14
    push r15

    ; YES THIS IS FOUR NESTED FOR LOOPS SHUT UP

    xor r12, r12
.row_loop:        ; for (r12 = 0; r12 < 16; r12 += 4) {
    xor r13, r13
.line_loop:       ;     for (r13 = 0; r13 < 5; r13++) {
    xor r14, r14
.column_loop:     ;         for (r14 = 0; r14 < 4; r14++) {
    mov rax, r12
    add rax, r14

    xor r15, r15
    mov r15w, [board + 2*rax] ; move the value of the current tile into rdi
    mov rdi, r15
    call ilog2         ; set_box_color(
    mov rdi, rax       ;   ilog2(tile)
    call set_box_color ; );

    cmp r13, 2
    je .value_line
.simple_line:
    mov rsi, tile_line
    mov rdx, tile_line_len
    jmp .line_done
.value_line:

    mov rdi, rewritable_tile_line
    mov rsi, tile_line
    mov rdx, tile_line_len
    call memcpy

    sub rsp, 8   ; reserve 8 bytes on the stack for the buffer
    mov rdi, r15
    mov rsi, rsp
    call itoa    ; convert the tile value to a string

    mov rdi, rewritable_tile_line
    add rdi, 3 ; center(ish) the output value
    mov rsi, rsp
    mov rdx, rax
    call memcpy  ; copy the value into the printed line
    add rsp, 8   ; restore stack

    mov rsi, rewritable_tile_line
    mov rdx, rewritable_tile_line_len
.line_done:
    call print

    call reset_color ; reset out terminal color
    mov rsi, space
    mov rdx, space_len
    call print       ; print a space between each box

    inc r14
    cmp r14, 4
    jl .column_loop ;       } column_loop

    mov rsi, 0
    mov rdx, 0
    call println  ; just print a newline

    inc r13
    cmp r13, 5
    jl .line_loop ;     } line_loop

    mov rsi, 0
    mov rdx, 0
    call println ; just print a newline

    add r12, 4
    cmp r12, 16
    jl .row_loop;    } row_loop

    pop r15
    pop r14
    pop r13
    pop r12
    ret

; rdi: log2(box value)
set_box_color:
    push r12
    mov r12, rdi

    mov rdi, [bg_colors + rdi*8]

    mov rsi, bg_color_len
    call set_background

    cmp r12, 5
    jle .dark
.light:
    mov rdi, fg_color_light
    mov rsi, fg_color_light_len
    jmp .set
.dark:
    mov rdi, fg_color_dark
    mov rsi, fg_color_dark_len
.set:
    call set_foreground

    pop r12
    ret


section .data
    DEF_STR bg_color, "234"
    DEF_STR hello_world, "Hello world!"

    DEF_STR space, " "

    DEF_STR tile_line, "          "
    DEF_STR rewritable_tile_line, "          "

    board: dw 2, 4, 8, 16, \
              256, 128, 64, 32, \
              512, 1024, 2048, 0, \
              0, 0, 0, 0

    bg_color_0: db "235"
    bg_color_2: db "231"
    bg_color_4: db "230"
    bg_color_8: db "227"
    bg_color_16: db "221"
    bg_color_32: db "214"
    bg_color_64: db "208"
    bg_color_128: db "202"
    bg_color_256: db "196"
    bg_color_512: db "124"
    bg_color_1024: db "052"
    bg_color_2048: db "053"
    bg_color_len: equ 3

    DEF_STR fg_color_dark, "0"
    DEF_STR fg_color_light, "15"

    bg_colors: dq bg_color_0, bg_color_2, bg_color_4, bg_color_8, \
                  bg_color_16, bg_color_32, bg_color_64, bg_color_128, \
                  bg_color_256, bg_color_512, bg_color_1024, bg_color_2048
    