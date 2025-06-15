; Executable name     :     program2.asm
; Version	            :     1.0
; Created date	      :     12/6/2025
; Last update	        :     -
; Author	            :     AridsWolfgangX
; Description	        :     A simple assembly program that prints out my name to the terminal

section .data
	name db "AridsWolfgangX", 0xA	              ; Replace this section with your name
					                                    ; 0xA means newline
	name_len equ $ - name		                    ; Calculate lenght of the string

section .text
	global _start

_start:		
	                                          ; wrtie(int fd, const void *buf, size_t count)
	mov rax, 1		                            ; syscall number for write
	mov rdi, 1		                            ; file descriptor: stdout
	mov rsi, name	                	          ; pointer to message
	mov rdx, name_len                       	; length of message
				                                    ; exit(int status)
	mov rax, 60		                            ; syscall number for exit
	xor rdi, rdi		                          ; status = 0
	syscall			                              ; make system call
