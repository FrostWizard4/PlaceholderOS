	[bits 32]
	[global _start]
  [extern getoffset]
  [extern setcursor]
  [extern getcursor]
  [extern print_at_pm]
_start:
	pushad
	mov ebp, esp

  push 13
  push 0
  call getoffset
  add esp, 8

  push ax
  call setcursor
  add esp, 4

  call getcursor

	mov ebx, MSG_LOADED
	call print_at_pm
	jmp $

	mov esp, ebp
	popad
	ret

	MSG_LOADED db "Should be loaded!", 0
