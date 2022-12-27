
print_real:
	pusha
	mov bp, sp
	mov bx, [bp+8]
	
print_real_loop:
	mov al, [bx]

	cmp al, 0
	je print_real_done

	mov ah, 0x0e
	int 0x10

	add bx, 1

	jmp print_real_loop

print_real_done:
	mov sp, bp
	popa
	ret
