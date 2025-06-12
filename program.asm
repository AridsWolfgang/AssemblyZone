; Deffinition of the 'data' section
section .data
    msg db "Hello, World!", 0xA  	; Message to print
    len equ $ - msg             	; Length of the message

section .text
    global _start

_start:
    ; Write message to stdout
    mov rax, 1                  ; syscall: write
    mov rdi, 1                  ; file descriptor: stdout
    mov rsi, msg                ; pointer to message
    mov rdx, len                ; message length
    syscall

    ; Exit
    mov rax, 60                 ; syscall: exit
    xor rdi, rdi                ; status: 0
    syscall
