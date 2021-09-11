%include 'lib.inc'

section .data
test_string: db 'Hello', 0
word_buf: times 20 db 0xca
number: db '-12345', 0
string1: db 'Kesley1', 0
string2: db 'Kesley', 0

section .text

global _start

_start:
	mov rdi, string1
	mov rsi, string2

	call string_equals

	mov rdi, rax
	mov rax, 60
	syscall
