%define O_RDONLY	0x0
%define PROT_READ	0x1
%define MAP_PRIVATE	0x2

section .data
; The filename
fname: db 'test.txt', 0

section .text
global _start

print_string:
	push rdi
	call string_length
	pop rsi
	mov rdx, rax
	mov rax, 1
	mov rdi, 1
	syscall
	ret

string_length:
	xor rax, rax
.loop:
	cmp byte[rdi+rax], 0
	je .end
	inc rax
	jmp .loop

.end:
	ret

_start:
	; call open
	mov rax, 2
	mov rdi, fname
	mov rsi, O_RDONLY	; opening the file as read only
	mov rdx, 0			; not creating the file, so this has no meaning

	syscall

	; mmap
	mov r8, rax			; rax holds the opened file descriptor, 4th arg of mmap
	mov rax, 9			; mmap syscall num
	mov rdi, 0			; let OS choose the address
	mov rsi, 4096		; page size
	mov rdx, PROT_READ	; memory region will be marked read only
	mov r10, MAP_PRIVATE; pages will nor be shared

	mov r9, 0			; offset inside of test.txt
	syscall

	mov rdi, rax
	call print_string

my_breakpoint:

	mov rax, 60
	xor rdi, rdi
	syscall
