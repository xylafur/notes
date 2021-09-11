%define prev 0

; Macro to create dictionary words.
;  Takes two arguments, dict key and assembly label name
%macro colon 2
%%prev:
dq prev     ; Pointer to prev element in list
db %1, 0    ; Key
            ; Value goes here, placed by the caller of the macro
xt_ %+ %2:

%define prev %%prev
%endmacro

