  [bits 32]
  [global getcursor]
  [global setcursor]
  [global getoffset]
  [global getrowoffset]
MAX_COLS:
  db 80
MAX_ROWS:
  db 25

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

  ;; Set the cursor on the screen with an offset passed in from cl
setcursor:
  push ebp
  mov ebp, esp

  mov cx, [ebp+8]
  sar cx, 1                 ; Divide EAX by 2

  mov dx, 0x3d4
  mov ax, 14
  out dx, ax

  mov dx, 0x3d5
  mov ax, cx
  shr ax, 8
  out dx, ax

  mov dx, 0x3d4
  mov ax, 15
  out dx, ax

  mov dx, 0x3d5
  and cx, 0xff
  mov ax, cx
  out dx, ax

  mov esp, ebp
  pop ebp
  ret

  ;; Get the offset used in getrowoffset and getcoloffset, EAX and EBX used
  ;; EAX = row
  ;; EBX = col
getoffset:
  push ebp
  push esi
  mov ebp, esp
  xor edx, edx

  mov ebx, [ebp+12]
  mov eax, [ebp+16]

  mov esi, 80

  mul esi                       ; Multiply EAX by ESI
  add eax, ebx                  ; Add column value to row value
  shl eax, 1                    ; Multiply by 2

  mov esp, ebp
  pop esi
  pop ebp
  ret

  ;; Take an offset from EAX and find the row on the screen
getrowoffset:
  push ebp
  push esi
  push ecx
  mov ebp, esp
  xor edx, edx

  ;; Multiply the offset given in ECX by the maximum columns to give the position

  mov esi, 80                   ; Move the Maximum number of columns the screen can display into ESI
  shl esi, 1                    ; Multiply by 2, each character on the screen is made up of the color and background, and the char
  mov eax, esi                  ; Move ESI into EAX
  div ecx                       ; divide EAX by ECX

  mov esp, ebp
  pop esi
  pop ecx
  pop ebp
  ret

  ;; To get the column offset, just multiply rowoffset by MAX_COLS
