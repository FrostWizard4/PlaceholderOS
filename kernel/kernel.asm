	[bits 32]
	[global _start]	
_start:
	pushad
	mov ebp, esp

	;; C Example:
	;; port_byte_out(0x3d4, 14);
	;; int position = port_byte_in(0x3d5);
	;; position = position << 8;
	;; port_byte_out(0x3d4, 15);
	;; position += port_byte_in(0x3d5);
	;; int offset_from_vga = position * 2;
	;; offset_from_vga is the cursor position!

	mov eax, 0x520		; Intermediary until I implement ports
	mov ebx, MSG_LOADED
	call print_at_pm

	jmp $

	mov esp, ebp
	popad
	ret

	MSG_LOADED db "Should be loaded!", 0

 	%include "print_at_pm.asm"    ; TODO: Figure out a way to make _start be where execution starts so include's can be at the top
