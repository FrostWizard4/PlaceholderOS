	%include "../drivers/ports.asm"

kernel_start:
	pusha

	mov dx, 14
	mov al, 0x3d4
	call port_byte_out	; Request Byte 14 from 0x3d4

	mov dx, 0x3d5
	call port_byte_in	; Read a byte from 0x3d5, store in AH

	movsx bx, al		; Move AH into AX so we can use it, with Sign-Extension
	shl bx, 8		; Left shift AX by 8

	mov dx, 15
	mov al, 0x3d4
	call port_byte_out	; Request Byte 15 from 0x3d4

	mov dx, 0x3d5
	call port_byte_in	; Read a byte from 0x3d5 store in AH

	movsx cx, al		; Move AL into CX, with Sign-Extension
	add ax, cx		; add CX to AX FIX

	rol bx, 1		; Rotate AX 1 to the left

	popa
	ret
