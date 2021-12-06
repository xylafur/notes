%include "includes/lib.inc"
%include "includes/debug.inc"

section .data
looking:		db 'looking for: ', 0
found:			db 'found key:   ', 0

newline:		db 10, 0
spaces:			db '    ', 0
dump:			db 'Dumping entry:               ', 0
this_addr:		db '  This address:              ', 0
prev_addr:		db '  Previous address:          ', 0
this_key:		db '  Key:                       ', 0
this_val:		db '  Value:                     ', 0
dump_native_s:	db 'Dumping native:              ', 0
word_addr:		db '  Word Address:              ', 0
native_key:		db '  Key:                       ', 0
exec_addr:		db '  Execution Token Address:   ', 0
impl_addr:		db '  Implementaion Address:     ', 0
run_impl:		db '  Running Implementation:    ', 0

section .text

global find_word
global dump_entry_list
global dump_native

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

dump_entry:
	push rdi

	; Dumping entry..
	mov rdi, dump
	call print_string_newline

	; Dumping current address string
	mov rdi, this_addr
	call print_string
	; Dumping actual address
	mov rdi, qword[rsp]
	call print_uint
	call print_newline

	; Dumping previous address string
	mov rdi, prev_addr
	call print_string

	mov rdi, qword[rsp]
	mov rdi, [rdi]

	call print_uint
	call print_newline

	mov rdi, this_key
	call print_string

	add qword[rsp], 8
	mov rdi, qword[rsp]
	call print_string_newline

	mov rdi, qword[rsp]
	call string_length

	add rax, qword[rsp]
	add rax, 1

	pop rdi

	ret

; Dump out a native structure given the label for the word
dump_native:
	push rdi

	mov rdi, dump_native_s
	call print_string_newline

	mov rdi, word_addr

	mov rdi, qword[rsp]

	call dump_entry

	mov qword[rsp], rax

	mov rdi, impl_addr
	call print_string

	mov rdi, qword[rsp]
	mov rdi, [rdi]
	call print_uint
	call print_newline

	mov rdi, run_impl
	call print_string_newline

	mov rdi, qword[rsp]
	mov rdi, [rdi]

	call rdi

	pop rdi
	ret

dump_entry_list:
.loop:
	push rdi
	call dump_entry
	pop rdi
	call next_element
	mov rdi, rax
	test rax, rax
	jz .end
	jmp .loop
.end:
	ret




