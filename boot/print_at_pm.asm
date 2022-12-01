	[bits 32]
	;;  Constants!
	VIDEO_MEMORY equ 0xb8002 ; Memory Address for the current VGA Mode
	WHITE_ON_BLACK equ 0x0f	 ; Color of text and background

	;;  prints a null-terminated string pointed to by EDX
print_at_pm:
	pusha
	mov edx, VIDEO_MEMORY	; set EDX to the start of video memory
	add edx, ax

print_string_pm_at_loop:
	mov al, [ebx]		; Store the character at EBX in AL
	mov ah, WHITE_ON_BLACK	; Store the attributes in AH

	cmp al, 0		; jump to done if the character is null (0)
	je print_string_pm_at_done

	mov [edx], ax		; Store the character and current attributes at current character cell

	add ebx, 1		; Increment to next character
	add edx, 2		; Move to the next character cell in video memory multiples of 2 are spaces

	jmp print_string_pm_at_loop

print_string_pm_at_done:
	popa
	ret
