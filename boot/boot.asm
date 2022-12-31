	[org 0x7c00]
	KERNEL_OFFSET equ 0x1000
	mov [BOOT_DRIVE], dl     ; Remember that the BIOS sets us the boot drive in 'dl' on boot
	mov bp, 0x9000
	mov sp, bp

  mov bx, MSG_REAL_MODE
	call print_real         ; Print the message stored in BX
  call print_nl           ; Print a newline & carriage return

	call load_kernel 	      ; read the kernel from disk
	call switch_pm 		      ; disable interrupts, load GDT,  etc. Finally jumps to 'BEGIN_PM'
	jmp $ 			            ; Never executed

	%include "print_real.asm"
	%include "gdt.asm"
	%include "print_pm.asm"
	%include "switch_pm.asm"
	%include "boot_sect_disk.asm"
	%include "print_hex.asm"

[bits 16]
load_kernel:
	push bp			            ; Save the old base pointer value
	mov bp, sp		          ; Set the new value

	mov bx, MSG_LOAD_KERNEL	; Push the first parameter to the stack
	call print_real
  call print_nl

	mov bx, KERNEL_OFFSET 	; Read from disk and store in 0x1000
	mov dh, 16 		          ; Our future kernel will be larger, make this big
	mov dl, [BOOT_DRIVE]
	call disk_load

	mov sp, bp		          ; Deallocate local variables
	pop bp			            ; Restore the caller's base pointer value
	ret


[bits 32]
BEGIN_PM:
	push ebp
	mov ebp, esp

	mov ebx, MSG_PROT_MODE
	call print_pm

	call KERNEL_OFFSET
	jmp $

	mov esp, ebp
	pop ebp

	BOOT_DRIVE         db 0
	MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
	MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0
	MSG_LOAD_KERNEL db "Loading kernel into memory", 0

	times 510-($-$$) db 0
	dw 0xaa55


