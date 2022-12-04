	%include "../kernel/print_at_pm.asm"
	
[bits 32]
kernel_start:
	pusha

	mov dx, 14
	mov eax, 0x3d4
	out dx, eax 		; Request Byte 14 from 0x3d4

	mov dx, 0x3d5
	in eax, dx		; Read a byte from 0x3d5, store in AL
	mov ebx, eax		; Move AL into BX so we can use it, with Sign-Extension
	shl ebx, 8		; Left shift BX by 8

	mov dx, 15
	mov eax, 0x3d4
	out dx, eax		; Request Byte 15 from 0x3d4

	mov dx, 0x3d5
	in eax, dx		; Read a byte from 0x3d5 store in AL

	mov ecx, eax		; Move AL into CX, with Sign-Extension
	add ebx, ecx		; add CX to BX

	rol ebx, 1		; Rotate BX 1 to the left

	;; Now that we have the offset we need (BX), we just need to pass that into print_at_pm
	mov ecx, ebx
	mov ebx, MSG_LOADED
	call print_at_pm

	jmp $
	
	popa
	ret

	MSG_LOADED db "Should be loaded!", 0
