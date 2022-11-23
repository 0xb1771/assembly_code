extern exit, string_length
global _start

section .data

test_string: db 'How much am i long?', 0

section .text

_start:
  mov rdi, test_string
  call string_length
  mov rdi, rax
  call exit
