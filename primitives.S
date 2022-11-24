global exit, string_length, print_string, print_char, print_newline, print_uint, print_int, read_char

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

; prints a character code to stdout
;
;   - rdi   a character code
print_char:
  push rbp
  mov rbp, rsp
  sub rsp, 4
  mov [rbp-4], dil
  mov rdx, 1
  lea rsi, [rbp-4]
  mov rdi, 1
  call write_syscall
  add rsp, 4
  mov rsp, rbp
  pop rbp
  ret

; prints a newline character code to stdout
print_newline:
  mov rdi, 0xA
  call print_char
  ret

; prints an 8-byte unsigned integer in decimal format to stdout
;
;   - rdi   an unsigned 8-byte integer
print_uint:
  push rbp
  mov rbp, rsp
  mov rax, rdi                                      ; the integer to print
  mov rsi, 10                                       ; the divisor
  mov rcx, 0                                        ; digit counter

  print_uint_int_digit_to_char_conversion_loop:
  mov rdx, 0                                        ; zeeroize the remainder
  div rsi

  ; rdx will store the remainder of division by 10, that is the digit we want to print
  ; and in rax we have the quotient, that is the other digit we still need to convert

  add rdx, 0x30                                     ; convert the digit in corrisponding ascii char
  push rdx
  inc rcx                                           ; increment the digit converted counter
  cmp rax, 0
  jnz print_uint_int_digit_to_char_conversion_loop

  ; now we pop digit from the stack and print them
  jmp print_uint_print_digit_loop_check 
  print_uint_print_digit_loop:
  pop rdi
  push rcx                                          ; rcx is a caller-saved reg. Is used by linux system call and needs to be saved and restore before calling sbroutine 
  call print_char
  pop rcx
  dec rcx
  print_uint_print_digit_loop_check:
  cmp rcx, 0
  jne print_uint_print_digit_loop
  mov rsp, rbp
  pop rbp
  ret

; prints an 8-byte signed integer in decimal format to stdout
;
;   - rdi   an signed 8-byte integer
print_int:
  push rbp
  mov rbp, rsp
  sub rsp, 0x8
  mov [rbp-0x8], rdi
  cmp dword [rbp-0x8], 0
  jg print_int_digit
  call print_minus
  mov rdi, [rbp-0x8]
  neg rdi
  print_int_digit:
  call print_uint
  add rsp, 0x8
  mov rsp, rbp
  pop rbp
  ret

; reads one char from stdin and returns it. Returns 0 if the end of input stream occurs.
read_char:
  push rbp
  mov rbp, rsp
  sub rsp, 0x4
  mov rdi, 0                  ; stdin as first argument
  lea rsi, [rbp-0x4]          ; a pointer to a 4 byte buffer in the stack
  mov rdx, 1                  ; read 1 byte
  call read_syscall
  cmp rax, 0
  jle read_char_error
  movzx rax, byte [rbp-0x4]   ; mov the char into rax
  jmp read_char_exit
  read_char_error:
  mov rax, 0
  read_char_exit:
  add rsp, 0x4
  mov rsp, rbp
  pop rbp
  ret

; accepts a buffer address and size as arguments. Reads next word from stdin
; (until whitespaces occurs). Stops and returns 0 if word is too big for the
; buffer specified; otherwise returns the buffer address.
;
; - rdi buffer address to store string
; - rsi size of the word to read
;
; notes: whitespaces are: space, tabulation, line break 0x20,0x9,0x10
read_word:
  push rbp
  mov rbp, rsp
  sub rsp, 0x18                     ; allocate 24 bytes to store the two arguments and char reads counter (qword)
  mov [rbp-0x10], rdi               ; buffer address
  mov [rbp-0x8], rsi                ; buffer size
  mov qword [rbp-0x18], 0           ; number of character read counter
  read_char_loop:
  call read_char
  cmp rax, 0x20
  je read_word_string_end
  cmp rax, 0x9
  je read_word_string_end
  cmp rax, 0x10
  je read_word_string_end
  mov rsi, [rbp-0x8]
  cmp [rbp-0x18], rsi                ; check if bytes read can be stored in the buffer
  jge read_word_buffer_overflow 

  cmp []
  push rax
  inc qword [rbp-0x18]
  read_word_string_end:

  read_word_buffer_overflow:
  mov rax, 0
  read_word_exit:
  mov 










;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; private functions
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


print_minus:
  mov rdi, 0x2d                                         ; - char ascii code
  call print_char
  ret

exit_sycall:
  mov rax, 60
  syscall

write_syscall:
  mov rax, 1
  syscall
  ret

read_syscall:
  mov rax, 0
  syscall
  ret