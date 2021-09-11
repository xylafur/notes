%macro debug_print_reg 2
push rdi
push rsi
push rdx
push rcx
push r8
push r9
push rax
push rdx

push %2

mov rdi, %1
call print_string

pop %2

mov rdi, %2
call print_string_newline

pop rdx
pop rax
pop r9
pop r8
pop rcx
pop rdx
pop rsi
pop rdi
%endmacro


