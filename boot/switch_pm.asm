[bits 16]
switch_pm:
	cli			; Switch off interrupts for the moment!
	lgdt [gdt_descriptor]	; Load our shitty GDT

	mov eax, cr0		; Set the first bit of CR0, a control register
	or eax, 0x1		; cr0: Protected Mode Enable, 1 is Protected
	mov cr0, eax

	jmp CODE_SEG:init_pm	; Make a far jump to our 32-bit code, also forces the CPU to flush its cache of pre-fetched and real-mode
				; decoded instruction, which is a no-no


[bits 32]			; initialize registers and the stack once we're in PM
init_pm:

	mov ax, DATA_SEG	; Point all the segment registers to the data selector we defined in the GDT
	mov ds, ax		; Limit: 0xffff
	mov ss, ax		; Base: 0x0
	mov es, ax		; Base: 0x0
	mov fs, ax		; Present, Privilege, Desc type, Code, Conform., Read., Acc., 10010010b
	mov gs, ax		;; Gran., 32-bit, 64-bit, AVL -> 1100, Limit -> 11001111b

	mov ebp, 0x90000	; Update our stack position so it is right at the top of the free space
	mov esp, ebp

	call BEGIN_PM		; and so it begins
