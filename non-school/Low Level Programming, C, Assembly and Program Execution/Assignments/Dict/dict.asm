%include "includes/lib.inc"
%include "includes/debug.inc"

section .data
looking:		db 'looking for: ', 0
found:			db 'found key:   ', 0

dump:			db 'Dumping colon:', 0
newline:		db 10, 0
spaces:			db '    ', 0
this_addr:		db '    This address:     ', 0
prev_addr:		db '    Previous address: ', 0
this_key:		db '    Key:              ', 0
this_val:		db '    Value:            ', 0

section .text

global find_word
global dump_colon_list

; Arguments
;	rdi: address current element
; Returns
;	0 if last element, otherwise address of next element
next_element:
	mov rax, [rdi]
	ret

; Arguments
;	rdi: address current element
; Returns
;	Address of the value string
get_value:
	add rdi, 8		; this gives us the address of the key
	push rdi
	call string_length
	pop rdi
	add rax, rdi
	add rax, 1		; This is the address of the value, prev addr + string + byte
	ret

get_key:
	add rdi, 8		; this gives us the address of the key
	mov rax, rdi
	ret

; Arguments:
;   rdi: Null terminated key to search for
;   rsi: Pointer to the last word of the dict
; Returns:
;   0 if record not found, otherwise address of the record
find_word:
.loop:
	push rdi
	push rsi
	push rdi

	mov rdi, rsi
	call get_key
	mov rsi, rax

	pop rdi

	call string_equals

	test rax, rax
	pop rax
	jnz .found

	push rax
	mov rdi, rax
	call next_element
	pop rsi
	test rax, rax
	jz .not_found
	mov rsi, rax
	pop rdi
	jmp .loop
.found:
	mov rdi, rax
	call get_value
	jmp .end
.not_found:
	mov rax, 0
.end:
	pop rdi
	ret

dump_colon:
	push rdi
	mov rdi, dump
	call print_string_newline

	mov rdi, this_addr
	call print_string

	pop rdi
	push rdi

	call print_uint
	mov rdi, newline
	call print_string

	mov rdi, prev_addr
	call print_string

	pop rdi
	push rdi

	mov rdi, [rdi]

	call print_uint
	mov rdi, newline
	call print_string

	mov rdi, this_key
	call print_string

	pop rdi
	add rdi, 8
	push rdi
	call print_string_newline

	mov rdi, this_val
	call print_string

	pop rdi
	push rdi
	call string_length
	pop rdi
	add rdi, rax
	add rdi, 1
	call print_string_newline

	ret

dump_colon_list:
.loop:
	push rdi
	call dump_colon
	pop rdi
	call next_element
	mov rdi, rax
	test rax, rax
	jz .end
	jmp .loop
.end:
	ret




