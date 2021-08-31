global _start

section .data
message: db 'hello, world', 10	; 10 is the code for newline

section .text
_start:
	mov	rax,	1				;system call number should be stored in rax
	mov	rdi,	1				;argument #1 is rdi: for write, its where to write (the file descriptor)
	mov rsi,	message			;argument #2 in rsi: where does the string start?
	mov rdx,	14				;argument #3 in rdx: how many bytes to write?

	syscall						;invoke the system call

	mov	rax,	60				;exit syscall number
	xor	rdi, rdi
	syscall
