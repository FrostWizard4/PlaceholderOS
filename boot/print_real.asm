
print_real:
  ;; Typical function prologue
	pusha
	mov bp, sp

print_real_loop:
	mov al, [bx]                  ; BX is the base address for the string

	cmp al, 0                     ; Check to see if we have reached the end
	je print_real_done            ; If so, jump to the function epilogue

	mov ah, 0x0e                  ; BIOS operation Teletype Output
	int 0x10                      ; Call interrupt vector

	add bx, 1                     ; Increment to the next character in the string

	jmp print_real_loop           ; Rinse, wash and repeat!

print_real_done:
  ;; Typical function epilogue
	mov sp, bp
	popa
	ret

print_nl:
  pusha
  mov bp, sp

  mov ah, 0x0e                  ; BIOS op-code TTY
  mov al, 0x0a                  ; Let's print a newline!
  int 0x10
  mov al, 0x0d                  ; ..and a carriage return, beginning of the newline!
  int 0x10

  mov sp, bp
  popa
  ret
