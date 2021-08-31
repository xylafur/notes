section .data
codes:
	db	'0123456789abcdef'
newline:
	db 10

section .text
global _start
_start:
	; number 1122... in hexadecimal format
	mov rax,	0x1122334455667788

	mov rdi, 1
	mov rdx, 1
	mov rcx, 64
	; Each 4 bits should be output as one hexdecimal digit
	; Use shift and bitwise AND to isolate them
	; the result is the offset in 'codes' array

	.loop:	; Since .loop starts with a dot, that makes it a local label, meaning we
			; can reuse it later without causign a conflict
			; We can to refer to this loop anywhere in the code by usint _start.loop
			; <global>.<local>
		push rax
		sub rcx, 4
		; cl is a register, least significant nibble of rcx
		sar rax, cl	; shift right by cl
		and rax, 0xf

		lea rsi, [codes + rax]
		mov rax, 1

		push rcx
		syscall	; write
		pop rcx

		pop rax

		test rcx, rcx
		jnz .loop

	mov rax, 1
	mov rdi, 1
	mov rsi, newline
	mov rdx, 1
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall





