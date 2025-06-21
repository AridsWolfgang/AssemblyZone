; Simple Guess the Number game in 16-bit x86 assembly
; targer: DOS, runs in DOSBox
[org 0x100]       ; COM file origin for DOS
[bits 16]

section .data 
  prompt          db    'Guess a number (0 - 9): $'
  msgCorrect      db    'Correct!$'
  msgWrong        db    'Wrong!$'
  newline         db    0x0D, 0x0A, '$'               ; CR+LF for DOS


section .text 
start:
  ; Print "Guess a number (0-9): "
  mov ah, 0x09                   ; DOS function: print string
  mov dx, prompt                 ; Address of prompt string 
  int 0x21                       ; Call DOS interrupt

  ; Read a single character (0-9)
  mov ah, 0x01                   ; DOS function: read character with echo 
  int 0x21                       ; Get input in AL 
  sub al, '0'                    ; Convert ASCII digit to number (e.g., '5' -> 5)

  ; Compare with the secret number (7)
  cmp al, 7                     ; Compare input with 7
  je correct                    ; Jump if equal to correct label 

  ; Print 'Wrong!'
  mov ah, 0x09
  mov dx, msgWrong
  int 0x21 
  jmp done 

correct:
  ; Print 'Correct!'
  mov ah, 0x09 
  mov dx, msgCorrect
  int 0x21 

done: 
  ; Print newline
  mov ah, 0x09
  mov dx, newline 
  int 0x21 

  ; Exit to DOS 
  mov ah, 0x4C            ; DOS function: terminal program 
  mov al, 0               ; Return code 0
  int 0x21
