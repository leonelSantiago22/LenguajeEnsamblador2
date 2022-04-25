.MODEL SMALL
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
ini:	mov ah,01h
		int 21h
		mov bl,al
		cmp bl,0Dh
		je sal
		cmp al,60h
		jl conv
		sub al,20h
		mov dl,al
		mov ah,02h
		int 21h
		jmp ini
conv:	add al,20h
		mov dl,al
		mov ah,02h
		int 21h
		jmp ini
sal:	.exit 0

end