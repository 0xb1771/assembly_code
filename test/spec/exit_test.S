extern exit
global _start

section .text

_start:
  mov rdi, 0
  call exit
