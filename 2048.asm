global _start

section .text

_start:
  mov rax, 1        ; write(
  mov rdi, 1        ;   STDOUT_FILENO,
  mov rsi, ansiRed  ;   ansiRed,
  mov rdx, ansiLen  ;   sizeof(ansiRed)
  syscall           ; );

  mov rax, 1        ; write(
  mov rdi, 1        ;   STDOUT_FILENO,
  mov rsi, msg      ;   "Hello, world!\n",
  mov rdx, msglen   ;   sizeof("Hello, world!\n")
  syscall           ; );

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
  mov rax, 1
  mov rdi, 1
  mov rsi, triangle
  mov rdx, triLen
  syscall
exit:
  mov rax, 60       ; exit(
  mov rdi, 0        ;   EXIT_SUCCESS
  syscall           ; );

section .data
  msg: db "Hello, world!", 10
  msglen: equ $ - msg
  maxLines: equ 8
  triLen: equ 44

  ansiRed: db 27,"[31m"
  ansiLen: equ $ - ansiRed

section .bss
  triangle: resb triLen