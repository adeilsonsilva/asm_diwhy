; **********************************************
; * Procedure in Assembly
; * Created by Adeilson Silva (github.com/adeilsonsilva)
; **********************************************

; **********************************************
; * '.data' section
; * All the constant values are defined here.
; **********************************************
section .data

; **********************************************
; * '.bss' section
; * All the variables are defined here.
; **********************************************
section .bss
    ; Allocating 64 bytes of space for unitialized variable
    valueToPrint:    RESB    64
    length:          RESB    64

; **********************************************
; * '.text' section
; * All the executable code is defined here.
; **********************************************
section .text
    ; Must be declared for linker (ld)
    global _start

; %%%%%%%%%%%%%%%%%%%%%%
; % This procedure makes a syscall to print a string
; %
; % @param    valueToPrint  str to be printed
; % @param    length        length of the str to be printed
; %%%%%%%%%%%%%%%%%%%%%%
print_value:
    mov  edx, [length]        ; Message length
    mov  ecx, valueToPrint    ; Message to print
    mov  ebx, 1               ; File descriptor (stdout)
    mov  eax, 4               ; Syscall number (sys_write)
    int  0x80                 ; Call kernel

    ret                       ; Returns

; %%%%%%%%%%%%%%%%%%%%%%
; % Program entrypoint
; %%%%%%%%%%%%%%%%%%%%%%
_start:
    ; moves a str to be printed to a variable
    ;
    ; notice that 'mov' instruction is used with modifier
    ; as it can't infer the number of bytes being moved
    ;
    ; also, we increment the offset to append the str to the end of variable
    ;
    ; we finish the str with a '\n' char
    mov qword [valueToPrint], 'valu'
    mov qword [valueToPrint+4], 'eToP'
    mov qword [valueToPrint+8], 'rint'
    mov qword [valueToPrint+12], 'My4s'
    mov qword [valueToPrint+16], 's'
    mov qword [valueToPrint+20], 0x0D0A     ; '\n'
    mov dword [length], 64                  ; length of str being printed, sys_write uses it
    call print_value

    mov  eax, 1               ; Syscall number (sys_exit)
    int  0x80                 ; Call kernel
