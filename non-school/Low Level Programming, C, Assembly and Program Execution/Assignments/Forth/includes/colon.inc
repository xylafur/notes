%define pc r15
%define w r14
%define rstack r13

next:
    ret

docol:
    sub rstack, 8
    mov [rstack], pc
    add w, 8
    mov pc, w
    jmp next


%define prev 0

%macro entry 2
w_ %+ %2:
    %%prev:
    dq prev     ; Pointer to prev element in list
    db %1, 0    ; Key
                ; Value goes here, placed by the caller of the macro
xt_ %+ %2:

%define prev %%prev
%endmacro

%macro colon 2
entry %1, %2
    dq docol
%endmacro


; Word Name, Identifier, Flags
%macro native3 3
section .data
entry %1, %2
dq %2 %+ _impl

section .text
%2 %+ _impl:

%endmacro

; Word Name, Identifier
%macro native 2
native3 %1, %2, 0
%endmacro
