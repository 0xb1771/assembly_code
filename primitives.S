global exit, string_length, print_string

section	.text

; exit the program returning exit code
; 
;   - rdi   exit code
exit:
  call exit_sycall

; returns the length of a string
;
;   - rdi   a pointer to a string
;
; notes:  string should be NULL terminated
string_length:
  mov rax, 0                      ; string length counter and index in the string buffer
  jmp string_length_loop_check
  string_length_loop:
  inc rax
  string_length_loop_check:
  cmp byte [rdi+rax], 0                ; check if string char is 0 (string ends)
  jne string_length_loop
  ret

; prints a string to stdout
;
;   - rdi   a pointer to a string
print_string:
  call string_length
  mov rdx, rax                    ; string length as 3d argument
  mov rsi, rdi                    ; string pointer as 2nd argument
  mov rdi, 1                      ; stdout fd as 1st argument
  call write_syscall
  ret

; private functions
exit_sycall:
  mov rax, 60
  syscall

write_syscall:
  mov rax, 1
  syscall
  ret