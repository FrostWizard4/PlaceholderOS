	[bits 32]
	%include "print_pm.asm"
	mov ebx, MSG_DEBUG
	call print_pm
	jmp $

	MSG_DEBUG db "DEBUG", 0
