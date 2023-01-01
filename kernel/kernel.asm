	[bits 32]
	[global _start]
_start:
	pushad
	mov ebp, esp

  call getcursor
	mov ebx, MSG_LOADED
	call print_at_pm

	jmp $

	mov esp, ebp
	popad
	ret

	MSG_LOADED db "Should be loaded!", 0

 	%include "print_at_pm.asm"    ; TODO: Figure out a way to make _start be where execution starts so include's can be at the top
  %include "../drivers/screen.asm"
