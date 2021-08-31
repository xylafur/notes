global _start

section .data
string: db 'hello world', 0

section .text

strlen:
	mov rax, 0

.loop:
	cmp byte [rdi + rax], 0
	je .end
	inc rax
	jmp .loop

.end:
	ret

_start:
	mov rdi, string
	call strlen

	mov rdi, rax
	mov rax, 60
	syscall
