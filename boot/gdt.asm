;;;  Code Segment
;;;  Base: 0x0
;;;  Limit: 0xffff
;;;  Present: 1, since segment is present, used for virtual memory
;;;  Privilege: 0, ring 0 is the highest privilege
;;;  Descriptor type: 1 for code or data segments, 0 for traps
;;;  Type:
;;; 	-Code: 1 for code, since this is a code segment
;;;  	-Conforming: 0, memory protection, can't access code in this segment
;;;  	-Readable: 1, 0 is executable only, read allows us to read consts
;;;  	-Accessed: 0, debugging
;;;  Granularity: 1, greater span of memory
;;;  32-bit default: 1, 0 for 16-bit code, 1 for 32-bit code
;;;  64-bit code segment: 1, unused of 32-bit processor
;;;  AVL: 0, User defined, not using now.

;;;  NOTE: Data segment will be the same, except for Code (0), Expand Down (0), Writable (1),
;;;  and Accessed (0)

gdt_start:
	dd 0x0
	dd 0x0

gdt_code:			; Code Segment Descriptor
	dw 0xffff		; Limit
	dw 0x0			; Base
	db 0x0			; Base again
	db 10011010b		; Present, Privilege, Desc type, Code, Conform., Read., Acc., 10011010b
	db 11001111b		; Gran., 32-bit, 64-bit, AVL -> 1100, Limit -> 11001111b
	db 0x0
	
gdt_data:			; Data Segment Descriptor, remember, slightly different!
	dw 0xffff		; Limit
	dw 0x0			; Base
	db 0x0			; Base again
	db 10010010b		; Present, Privilege, Desc type, Code, Conform., Read., Acc., 10010010b
	db 11001111b		; Gran., 32-bit, 64-bit, AVL -> 1100, Limit -> 11001111b
	db 0x0

gdt_end:
	
gdt_descriptor:
	dw gdt_end - gdt_start - 1 ; Size of the GDT, always less one of the true size
	dd gdt_start		   ; Start address of the GDT

	CODE_SEG equ gdt_code - gdt_start
	DATA_SEG equ gdt_data - gdt_start
