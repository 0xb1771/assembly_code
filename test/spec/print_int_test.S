extern exit, print_int
global _start

section .data

section .text

_start:
  mov rdi, -98
  call print_int
  mov rdi, 0
  call exit
