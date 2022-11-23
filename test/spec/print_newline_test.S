extern exit, print_newline
global _start

section .data

section .text

_start:
  call print_newline
  mov rdi, 0
  call exit
