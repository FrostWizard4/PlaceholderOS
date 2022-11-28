

print_real:
	pusha

print_real_loop:
	mov al, [bx]

	cmp al, 0
	je print_real_done

	mov ah, 0x0e
	int 0x10

	add bx, 1

	jmp print_real_loop

print_real_done:
	popa
	ret
