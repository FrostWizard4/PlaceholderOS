	[org 0x7c00]

	KERNEL_OFFSET equ 0x1000 	; The same one we used when linking the kernel

	mov [BOOT_DRIVE], dl ; Remember that the BIOS sets us the boot drive in 'dl' on boot
	mov bp, 0x9000
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print_pm

	call load_kernel 	; read the kernel from disk
	call switch_pm 		; disable interrupts, load GDT,  etc. Finally jumps to 'BEGIN_PM'
	jmp $ 			; Never executed

	%include "print_real.asm"
	%include "gdt.asm"
	%include "print_pm.asm"
	%include "switch_pm.asm"
	%include "boot_sect_disk.asm"

[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_real

	mov bx, KERNEL_OFFSET
	mov dh, 2
	mov dl, [BOOTDRIVE]
	call disk_load
	ret
	
[bits 32]
BEGIN_PM:

	mov ebx, MSG_PROT_MODE
	call print_pm
	
	jmp $

	BOOT_DRIVE db 0
	MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
	MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0
	MSG_LOAD_KERNEL db "Loading kernel into memory", 0
	
	times 510-($-$$) db 0
	dw 0xaa55

	
