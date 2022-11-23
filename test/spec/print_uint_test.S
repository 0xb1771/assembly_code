extern exit, print_uint
global _start

section .data

section .text

_start:
  mov rdi, 45689
  call print_uint
  mov rdi, 0
  call exit
