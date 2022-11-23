extern exit, print_string
global _start

section .data

test_string: db 'How much am i long?', 0

section .text

_start:
  mov rdi, test_string
  call print_string
  mov rdi, 0
  call exit
