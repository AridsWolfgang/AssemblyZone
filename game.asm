; Click the Target game in 64-bit Linux with Xlib
; NASM, links with libX11
; Compile: nasm -f elf64 -o clickDTarget.o clickDTarget.asm && gcc -o clickDTarget clickDTarget.o -lX11 -no-pie 
; Run: ./clickDTarget
  
extern XOpenDisplay, XCreateSimpleWindow, XMapWindow, XSelectInput, XNextEvent
extern XFillRectangle, XCreateGC, XSetForeground, XFlush
extern printf, exit 

section .data 
  hit_msg     db    "Hit!", 0xA, 0
  miss_msg    db    "Miss!", 0xA, 0
  target_x    equ   50
  target_y    equ   50
  target_w    equ   50
  target_h    equ   50

section .bss 
  display resq 1 
  window resq 1 
  gc resq 1 
  event resb 128        ; XEvent structure (approx size)

section .text 
global main 
main: 
  ; Open display 
  xor rdi, rdi        ; NULL for default display 
  call XOpenDisplay
  mov [display], rax  ; Save display pointer
  test rax, rax
  jz exit_program     ; Exit if display fails

  ; create window 
  mov rdi, [display]
  mov rsi, 0      ; Default root window
  mov rdx, 0      ; x 
  mov rcx, 0      ; y 
  mov r8, 200     ; width 
  mov r9, 200     ; height 
  push 0          ; depth (default)
  push 0          ; class (default)
  push 0          ; border width 
  call XCreateSimpleWindow
  mov [window], rax     ; Save window handle 

  ; Map window (make visible)
  mov rdi, [display]
  mov rsi, [window]
  call XMapWindow

  ; Create Graphics Context 
  mov rdi, [display]
  mov rsi, [window]     ; Default values
  mov rdx, 0 
  mov rcx, 0
  call XCreateGC 
  mov [gc], rax         ; Save GC 

  ; Set red color for target 
  mov rdi, [display]
  mov rsi, [gc] 
  mov rdx, 0xFF0000   ; Red (RGB)
  call XSetForeground

  ; Draw red rectangle (target) 
  mov rdi, [display]
  mov rsi, [window]
  mov rdx, [gc]
  mov rcx, target_x       ; x 
  mov r8, target_y        ; y 
  mov r9, target_w        ; width 
  push target_h           ; height 
  call XFillRectangle
  add rsp, 8

  ; Flush to display 
  mov rdi, [display]
  call XFlush 

  ; Select Mouse click events 
  mov rdi, [display] 
  mov rsi, [window] 
  mov rdx, 0x0001             ; ButtonPressMask 
  call XSelectInput

  ; Event loop (wait for one click) 
  mov rdi, [display]
  mov rsi, event 
  call XNextEvent

  ; Check click coordinates
  mov eax, [event + 48]       ; XButtonEvent.x (offset in XEvent)
  mov ebx, [event + 52]       ; XButtonEvent.y 
  cmp eax, target_y
  jl miss 
  cmp eax, target_x + target_y 
  jg miss 
  cmp ebx, target_y + target_h 
  jg miss 

  ; Print Hit! 
  mov rdi, hit_msg 
  call printf 
  jmp exit_program 
  
miss:
  ; Print "Miss"
  mov rdi, miss_msg 
  call printf 

exit_program:
  ; Exit 
  xor rdi, rdi 
  call exit 


