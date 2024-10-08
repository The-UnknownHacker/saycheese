%include "syscall.asm"
%include "print.asm"

global _start

section .text

_start:
  mov rsi, ansiRed  ;   print(ansiRed,
  mov rdx, ansiLen  ;   sizeof(ansiRed)
  call print           ;   );

  mov rsi, msg      ;   println("Hello, world!",
  mov rdx, msglen   ;   sizeof("Hello, world!")
  call println      ;   );

  mov rdx, triangle
  mov r8, 1
  mov r9, 0
line:
  mov byte [rdx], "*"
  inc rdx
  inc r9
  cmp r8, r9
  jne line
lineEnd:
  mov byte [rdx], 10
  inc rdx
  inc r8
  mov r9, 0
  cmp r8, maxLines
  jng line
done:
  mov rsi, triangle
  mov rdx, triLen
  call print
exit:
  mov rax, 60       ; exit(
  mov rdi, 0        ;   EXIT_SUCCESS
  syscall           ; );

section .data
  msg: db "Hello, world!"
  msglen: equ $ - msg

  maxLines: equ 8
  triLen: equ 44

  ansiRed: db 27,"[31m"
  ansiLen: equ $ - ansiRed

section .bss
  triangle: resb triLen