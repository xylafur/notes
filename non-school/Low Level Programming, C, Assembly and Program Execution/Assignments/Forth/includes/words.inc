%include "includes/lib.inc"
%include "includes/colon.inc"

section .data

debug_str:      db 'In native', 0

;native '+', plus
;    pop rax
;    add [rsp], rax
;    jmp next

native 't', test
    mov rdi, debug_str
    call print_string_newline
    ret

