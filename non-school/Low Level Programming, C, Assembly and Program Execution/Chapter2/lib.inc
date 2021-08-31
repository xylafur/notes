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

print_char:
    push rdi

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall

    pop rdi
    ret

print_newline:
    push r8
    mov r8, rsp

    sub rsp, 36

    mov byte[r8], 0xA

    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, 1
    syscall

    mov rsp, r8
    pop r8
    ret

print_uint:
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

	add rsp, 24

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

read_char:
    mov r8, rsp
    sub rsp, 8

    ; read 1 byte from stdin, store it at sp
    mov rax, 0
    mov rdi, 0
    mov rsi, rsp
    mov rdx, 1
    syscall

    mov al, byte[rsp]
    mov rsp, r8

    ret

read_word:
    push r15
    mov r15, 0
    ; Hold the start of the buffer address

.loop1:
    push rdi
    push rsi
    call read_char
    pop rsi
    pop rdi

    ; Check for whitespace, we want to ignore
    cmp al, ' '
    je .loop1
    cmp al, 13
    je .loop1
    cmp al, 9
    je .loop1
    cmp al, 10
    je .loop1

    test al, al
    jz .done

.loop2:
    ; add the character to our buffer
    mov byte[rdi + r15], al
    inc r15

    ; Check if we have reached the size
    cmp r15, rsi
    jge .to_big

    push rdi
    push rsi
    call read_char
    pop rsi
    pop rdi

    ; Whitespace after a valid character means end of word
    cmp al, ' '
    je .done
    cmp al, 13
    je .done
    cmp al, 9
    je .done
    cmp al, 10
    je .done

    test al, al
    jz .done
    jmp .loop2

.done:
    mov rax, rdi
    mov rdx, r15
    jmp .end


.to_big:
    mov rax, 0
    mov rdx, 0

.end:
    mov byte[rdi + r15], 0
    pop r15
    ret

string_copy:
    mov r8, 0
.loop:
    cmp r8, rdx
    je .end
    mov rcx, [rdi + r8]
    mov [rsi + r8], rcx
    inc r8
    jmp .loop
.end:
    ret

string_equals:
    xor rax, rax
    ret

; rdi points to a string
; returns rax: number, rdx : length
parse_uint:
    ;   rax:total,      rdx:char-count(index),  rsi:scratch(current val)
    ;   r8:running tot, r9:running index
    push r8
    push r9

    mov r8, 10
    xor r9, r9 
    xor rax, rax

.loop:
    xor rsi, rsi    ; zero out rsi so we can use the 64 bit version in a sec
    mov sil, byte[rdi + r9]
    cmp sil, 0
    jz .end

    mul r8  ; result is stored in rax, our total
    ; todo: What if overflow into rdx?

    sub rsi, 0x30
    add rax, rsi
    inc r9

    jmp .loop

.end:
    mov rdx, r9
    pop r9
    pop r8

    ret

; rdi points to a string
; returns rax: number, rdx : length
parse_int:
    xor rax, rax
    ret
