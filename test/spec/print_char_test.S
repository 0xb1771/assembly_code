extern exit, print_char
global _start

section .data

section .text

_start:
  mov rdi, 0x41
  call print_char
  mov rdi, 0
  call exit
