section .data
w_plus:
	dq 0		; The first word's pointer to the previous word is 0
	db '+',0
	db 0		; No flags
xt_plus:		; Execution Token for `plus`, the address of its implementation
	dq plus_impl
w_dup:
	dq w_plus
	db 'dup',0
	db0
xt_dup:
	dq dup_impl
w_double:
	dq w_dup
	db 'double',0
	db 0
	dq docol	; The `docol` address -- one level of indirection
	dq xt_dup	; The words consisting `dup` start here
	dq xt_plus
	dq xt_exit

last_word: qd w_double
section .text:
	plus_impl:
		pop rax
		add rax, [rsp]
		mov [rsp], rax
		jmp next
	dup_impl:
		push qword [rsp]
		jmp next



