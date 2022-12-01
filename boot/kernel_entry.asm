	[bits 32]
	[extern print_pm]
	mov ebx, MSG_DEBUG
	call print_pm
	jmp $

	MSG_DEBUG db "DEBUG", 0
