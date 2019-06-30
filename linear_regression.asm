; **********************************************
; * Linear Regression in Assembly
; * Created by Adeilson Silva (github.com/adeilsonsilva)
; *
; * This programs uses FPU registers to do floating point arithmetics
; * https://en.wikibooks.org/wiki/X86_Assembly/Floating_Point
; *
; * This program calls external (C) functions and uses x86-64 calling convention
; * https://en.wikipedia.org/wiki/X86_calling_conventions#x86-64_Calling_Conventions
; **********************************************

; **********************************************
; * '.data' section
; * All the constant values are defined here.
; **********************************************
section .data
    X:                DQ    0.10, 0.20, 0.30, 0.40, 0.50 ; Input data
    WEIGHTS:          DQ    0.43, 0.22, 0.87, 0.34, 0.11
    BIAS:             DQ    0.05
    INPUT_SIZE:       DQ    5
    format:           DB    "%.4f", 10, 0

; **********************************************
; * '.bss' section
; * All the variables are defined here.
; **********************************************
section .bss
    ; Allocating 64 bytes of space for unitialized variable
    valueToPrint:    RESB    64
    length:          RESB    64
    y:               RESB    64 ; Result of the regression
    offset:          RESB    64 ; Controls the loop addressing
    counter:         RESB    64 ; Controls the loop

; **********************************************
; * '.text' section
; * All the executable code is defined here.
; **********************************************
section .text
    extern printf
    ; Must be declared for linker (ld)
    global _start

; %%%%%%%%%%%%%%%%%%%%%%
; % This procedure makes a syscall to print a string
; %
; % @param    valueToPrint  str to be printed
; % @param    length        length of the str to be printed
; %%%%%%%%%%%%%%%%%%%%%%
print_value:
    mov  rdx, [length]        ; Message length
    mov  rcx, valueToPrint    ; Message to print
    mov  rbx, 1               ; File descriptor (stdout)
    mov  rax, 4               ; Syscall number (sys_write)
    int  0x80                 ; Call kernel

    ret                       ; Returns

; %%%%%%%%%%%%%%%%%%%%%%
; % Program entrypoint
; %%%%%%%%%%%%%%%%%%%%%%
_start:
    mov qword [valueToPrint], 0x09
    mov qword [valueToPrint+4], "init"
    mov qword [valueToPrint+8], 0x0D0A
    mov dword [length], 64
    call print_value
    mov qword [y], 0 ; initialize result with 0
    mov qword [offset], 0 ; initialize result with 0
    mov qword [counter], 0 ; initialize counter with 0

mult:

load_op1:
    ; reset fpu stacks to default
    finit
    ; print str
    mov qword [valueToPrint], "****"
    mov qword [valueToPrint+4], 0x0D0A
    call print_value
    ; Load first operator
    mov rbx, X
    add rbx, [offset]
    fld qword [rbx]
    ; call printf using x86-64 convention
    movsd xmm0, [rbx]
    mov rdi, format
    mov rax, 1
    call printf

load_op2:
    ; Load second operator
    mov rcx, WEIGHTS
    add rcx, [offset]
    fld qword [rcx]
    ; call printf using x86-64 convention
    movsd xmm0, [rcx]
    mov rdi, format
    mov rax, 1
    call printf

multiply:
    ; multiply
    fmul st0, st1
    ; call printf using x86-64 convention
    movsd xmm0, [y]
    mov rdi, format
    mov rax, 1
    call printf
    ; backup value to be acummulated in a general purpose register
    ; we use r15 because rcx and such were overwritten by system calls
    mov r15, [y]
    fstp qword [y] ; move multiply result to mem and pop stack
    ; call printf using x86-64 convention
    movsd xmm0, [y]
    mov rdi, format
    mov rax, 1
    call printf

cumsum:
    ; reset fpu stacks to default
    finit
    ; acummulate result and move back to memory
    fld qword [y]
    mov [y], r15
    fld qword [y]
    fadd
    fstp qword [y]
    ; call printf using x86-64 convention
    movsd xmm0, [y]
    mov rdi, format
    mov rax, 1
    call printf
    ; print str
    mov qword [valueToPrint], "****"
    mov qword [valueToPrint+4], 0x0D0A
    call print_value
    ; increase offset size
    add qword [offset], 8 ; 8 bytes
    add qword [counter], 1
    xor rcx, rcx
    mov rcx, [counter]
    cmp rcx, [INPUT_SIZE]
    jl mult

add_bias:
    ; reset fpu stacks to default
    finit
    fld qword [BIAS]
    fld qword [y]
    fadd
    fstp qword [y]

done:
    mov qword [valueToPrint], "resu"
    mov qword [valueToPrint+4], "lt: "
    mov qword [valueToPrint+8], 0x0D0A
    call print_value
    ; Print output
    movsd xmm0, [y]
    mov rdi, format
    mov rax, 1
    call printf

exit:
    mov  rax, 1               ; Syscall number (sys_exit)
    int  0x80                 ; Call kernel
