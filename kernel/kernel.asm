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

  mov dx, 0x3d4
  mov al, 14
  out dx, al

  mov dx, 0x3d5
  in al, dx
  mov cl, al

  shl cl, 8

  mov dx, 0x3d4
  mov al, 15
  out dx, al

  mov dx, 0x3d5
  in al, dx
  add cl, al

  movzx eax, cl	; Intermediary until I implement ports
  shl eax, 1    ; Multiply offset by 2
	mov ebx, MSG_LOADED
	call print_at_pm

	jmp $

	mov esp, ebp
	popad
	ret

	MSG_LOADED db "Should be loaded!", 0

 	%include "print_at_pm.asm"    ; TODO: Figure out a way to make _start be where execution starts so include's can be at the top
