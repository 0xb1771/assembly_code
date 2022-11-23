# Primitives

An assembly library holding x86-64 functions for basic operations. Written for linux operative system.


## Function arguments

Any function can accept an unlimited number of arguments. The first six arguments are passed in rdi, rsi, rdx, rcx, r8, and r9, respectively. The rest is passed on to the stack in reverse order.


## Calling conventions

Known conventions to keep in mind when writing functions.

### Caller-saved and calle-saved regiters

Executing a function can change registers.
There are two types of registers.

- Callee-saved registers must be restored by the procedure being called. So, if it needs
to change them, it has to change them back.


These registers are callee-saved: rbx, rbp, rsp, r12-r15, a total of seven registers.

- Caller-saved registers should be saved before invoking a function and restored after. One does not have to save and restore them if their value will not be of importance after.
All other registers are caller-saved.


## Linux syscall

In assembly syscalls get arguments in following registers.
The arguments for system calls are stored in a different set of registers than
those for functions. The fourth argument is stored in r10, while a function accepts the fourth argument in rcx.