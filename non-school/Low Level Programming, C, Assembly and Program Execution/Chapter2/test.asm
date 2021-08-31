global _start

section .data

section .text

string_length:
	mov rax, 0

.loop:
	cmp byte [rdi + rax], 0
	je .end
	inc rax
	jmp .loop

.end:
	ret



print_string:
    call string_length

    mov rdx, rax
    mov rax, 1
    mov rsi, rdi
    mov rdi, 1

    syscall

    ret

print_uint:
    mov r11, rsp
	mov r9, rsp

	add rsp, 24


	mov byte[r9], 0
	sub r9, 1

    mov r10, 10
    mov rax, rdi
	mov rdx, 0
	.loop:
    div r10
    add rdx, 0x30
    ;push rdx
    ;push dl
	mov byte[r9], dl
	sub r9, 1

    mov rdx, 0
    test rax, rax
    jnz .loop

	add r9, 1
    mov rdi, r9

    call print_string

    ; restore stack
    mov rsp, r11
    ret

print_int:
    cmp rdi, 0

    ; (0 - neg num) going to be gt 0
    jl .pos
.neg:
    mov r12, 1
    jmp .end
.pos:
    mov r12, 0
.end:
    neg rdi
    jl .end
    ; here we know that rdi holds the abs value and r12 is 1 if neg, 0 if pos

    mov r11, rsp
	mov r9, rsp

	add rsp, 32

	mov byte[r9], 0
	sub r9, 1

    mov r10, 10
    mov rax, rdi
	mov rdx, 0
.loop:
    div r10
    add rdx, 0x30
	mov byte[r9], dl
	sub r9, 1

    mov rdx, 0
    test rax, rax
    jnz .loop

.breaklabel:
    test r12, 1
    jne .pos2
    mov byte[r9], 0x2d
    jmp .end2
.pos2:
    add r9, 1

.end2:

    mov rdi, r9

    call print_string

    ; restore stack
    mov rsp, r11
    ret



_start:
	mov rdi, -1
	call print_int

	;mov rdi, 4321
	;call print_uint

	mov rdi, 0
	mov rax, 60
	syscall
