section .data
newline: db 10

section .text


global string_equals
global string_length
global print_string
global print_string_newline
global print_char
global print_newline
global print_uint
global print_int
global read_char
global read_word
global string_copy
global parse_uint
global parse_int

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

print_string_newline:
	call print_string

	mov rdi, newline
	call print_string

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

    sub rsp, 8

    mov r9, rsp

    sub rsp, 120


    mov byte[r9], 0
    sub r9, 1

    mov r10, 10
    mov rax, rdi
.loop:
    mov rdx, 0
    div r10
    add rdx, 0x30

    mov byte[r9], dl
    sub r9, 1

    test rax, rax
    jnz .loop

    add r9, 1
    mov rdi, r9
    push r11

    call print_string
    pop r11


    ; restore stack
    mov rsp, r11
    ret

print_int:
    cmp rdi, 0

    jl .pos         ; (0 - neg num) going to be gt 0
.neg:
    mov r12, 1
    jmp .end
.pos:
    mov r12, 0
.end:
    neg rdi
    jl .end         ; here we know that rdi holds the abs value and r12 is 1 if neg, 0 if pos

    mov r11, rsp

    sub rsp, 8
    mov r9, rsp
    sub rsp, 128


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

    test r12, 1
    jne .pos2
    mov byte[r9], 0x2d
    jmp .end2
.pos2:
    add r9, 1
.end2:
    mov rdi, r9

    push r11
    call print_string
    pop r11

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
    push r8
    push rcx
    push rdi
    push rsi

    mov r8, 0
.loop:
    cmp r8, rdx
    je .end
    mov rcx, [rdi + r8]

    test rcx, rcx
    jz .end

    mov [rsi + r8], rcx
    inc r8
    jmp .loop
.end:
    test rcx, rcx
    jnz .too_big            ; there is still more string left to move into buffer
    jmp .end2
.too_big:
    xor rax, rax
.end2:
    pop rsi
    pop rdi
    pop rcx
    pop r8

    ret

string_equals:
    xor rdx, rdx    ; index

.loop:
    mov r8b, byte[rdi + rdx]
    mov r9b, byte[rsi + rdx]
    cmp r8b, r9b
    jne .not_equal

    test r8b, r8b
    jz .str1_0

    test r9b, r9b
    jz .not_equal

    inc rdx
    jmp .loop

.str1_0:
    test r9b, r9b
    jnz .not_equal
.equal:
    mov rax, 1
    ret

.not_equal:
    mov rax, 0
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
    ; check if the number is positive, negative, or unspecified
    xor rdx, rdx
    mov dl, byte[rdi]

    ; Check if negative
    cmp dl, 45
    je .neg
    jmp .next1

.neg:
    push 1      ; Negative?
    push 1      ; Current character count
    inc rdi     ; Don't want to parse this guy
    jmp .call

    ; Check if positive
.next1:
    cmp dl, 43
    je .pos
    jmp .next2

.pos:
    push 0      ; Negative?
    push 1      ; Current character count
    inc rdi     ; Don't want to parse this guy
    jmp .call

.next2:
    push 0
    push 0

.call:

    call parse_uint

    pop r9      ; current Character count
    pop r10     ; Negative

    add rdx, r9

    cmp r10, 0
    je .return
    neg rax
.return:
    ret
