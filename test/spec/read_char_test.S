extern exit, read_char, print_char, print_string
global _start

section .data

error_msg: db 'Error: type at least 1 char', 0

section .text

_start:
  call read_char
  cmp rax, 0
  je main_read_error
  mov rdi, rax
  call print_char
  jmp main_exit
  main_read_error:
  mov rdi, error_msg
  call print_string
  main_exit:
  mov rdi, 0
  call exit
