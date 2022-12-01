	[bits 32]
	[global kernel_start]
	%include "../kernel/kernel.asm
	call kernel_start
	jmp $
