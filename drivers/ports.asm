port_byte_in:			; Read a byte from a port specified in DX and store in AL
	pusha			
	
	in al, dx		; Input byte from I/O port in DX into AL
	
	popa
	ret

port_byte_out:			; Output a byte to the port passed into AL, from DX
	pusha			

	out dx, al		; DX: Value to copy to
				; AL: I/O Port
	popa			
	ret		
	
port_word_in:			; Same as port_byte_in, but stored in a word
	pusha

	in ax, dx	
	

	popa
	ret

port_word_out:			; Same as port_byte_out, but stored in a word
	pusha

	out dx, ax

	popa
	ret

	
