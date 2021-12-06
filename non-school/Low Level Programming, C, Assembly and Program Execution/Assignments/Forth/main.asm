%include "includes/lib.inc"
%include "includes/words.inc"
%include "includes/dict.inc"

section .data
no_key:			db 'Did not find key', 0
searching_for:	db 'Searching for word: ', 0
found_string:	db 'Found value:        ', 0

section .text

global _start

_start:
	mov rdi, searching_for
	call print_string_newline

	mov rdi, w_test
	call dump_native

;	mov rdi, rsp
;	add rsp, 256
;
;	mov rsi, 256
;
;	call read_word
;
;	push rax
;	mov rdi, searching_for
;	call print_string
;	pop rax
;	push rax
;	mov rdi, rax
;	call print_string_newline
;	pop rax
;
;	mov rdi, rax
;	mov rsi, prev
;
;	call find_word
;	mov rdi, rax
;
;	test rax, rax
;	jz .not_found
;
;	push rax
;	mov rdi, found_string
;	call print_string
;	pop rax
;
;	mov rdi, rax
;	call print_string_newline
;	jmp .end
;
;.not_found:
;	mov rdi, no_key
;	call print_string_newline

.end:
	mov rdi, rax
	mov rax, 60
	syscall
