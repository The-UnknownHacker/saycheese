%include "syscall.asm"
%include "terminal.asm"
%include "utils.asm"

global _start

section .text

_start:
  mov rsi, red      ;   print(red,
  mov rdx, red_len  ;   sizeof(red)
  call print        ;   );

  call unbuffer     ; unbuffer stdin
poll_loop:
  call getchar
  cmp rax, 0        ; check if the character is `EOF`
  je poll_loop      ; try again if `EOF`

  push r12          ; r12 is a "preserved" register, so we have to save the contents
  mov r12, rax

  push qword 0      ; make space on the stack for the character
  mov rdi, r12      ; itoa(value: r12,
  mov rsi, rsp      ;      buffer: rsp
  call itoa         ; );

  mov rsi, rsp
  mov rdx, 3
  call println
  add rsp, 8

  cmp r12, 10
  je finish

  pop r12           ; retstore the saved contents of r12 
  jmp poll_loop
finish:
  call restore_buffer
  jmp exit

section .data
  DEF_STR red, 27,"[31m"

  board: dw 0, 0, 0, 0, \
            0, 0, 0, 0, \
            0, 0, 0, 0, \
            0, 0, 0, 0