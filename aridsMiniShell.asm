; Executable name   :   aridsmMiniShell.asm 
; Version           :   0.0.1
; Created Date      :   14/6/2025
; Last Updated      :   -
; Author            :   AridsWolfgangX
; Description       :   Building a  minimal linux shell in x86_64 Assembly

section .bss
    buffer resb 128         ; input buffer


section .text 
    global _start

_start:
.loop:
    ; Print prompt: "$ "
    mov rax, 1              ; syscall: write
    mov rdi, 1              ; fd: stdout
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Read User Input 
    mov rax, 0              ; syscall: read 
    mov rdi, 0              ; fd: stdin 
    mov rsi, buffer         ; buffer 
    mov rdx, 128            ; bytes to read
    syscall

    ; Replace newline with NULL terminator 
    mov rbx, buffer
.replace_newline:
    cmp byte [rbx], 10      ; newline?
    je .found_newline
    cmp byte [rbx], 0       ; end?
    je .found_newline
    inc rbx
    jmp .replace_newline
.found_newline:
    mov byte [rbx], 0       ; null terminate 
    
    ; Set up args: [filename, 0]
    mov rdi, buffer         ; filename = buffer
    mov qword [argv], buffer
    mov qword [argv+8], 0   ; null terminator
    mov rsi, argv           ; argv 
    xor rdx, rdx            ; envp = NULL 

    ; execve(buffer, [buffer, NULL], NULL)
    mov rax, 59              ; syscall execve
    syscall

    ; If execve fails, print error 
    mov rax, 1              ; syscall: write 
    mov rdi, 1              ; stdout
    mov rsi, error 
    mov rdx, error_len 
    syscall 

    jmp .loop 

section .data 
    prompt db "$ ", 0
    prompt_len equ $ - prompt 

    error db "Command failed. \n", 0 
    error_len equ $ - error

    argv dq 0, 0          ; array of 2 pointers: [command, NULL]

