  [bits 32]
  ;; API for interacting with the screen through Minima kernel
  ;; getcursor: function to grab the position of the cursor on the screen and store in EAX
getcursor:
  ;; Standard function prologue
  push ebp
  mov ebp, esp

  mov dx, 0x3d4
  mov al, 14
  out dx, al

  mov dx, 0x3d5
  in al, dx
  movzx ebx, al

  shl ebx, 8

  mov dx, 0x3d4
  mov al, 15
  out dx, al

  mov dx, 0x3d5
  in al, dx
  movzx ecx, al
  add ebx, ecx

  shl ebx, 1

  mov eax, ebx

  ;; Standard function epilogue
  mov esp, ebp
  pop ebp
  ret
