.MODEL SMALL
.STACK
.DATA
	msg1 db 0Dh,0Ah, "Mayuscula$"
	msg2 db 0Dh,0Ah, "Minuscula$"
.CODE
main:	mov ax,@data
		mov ds,ax
		mov ah,01h
		int 21h
		mov bl,al
		cmp bl,60h
		jl sal1
		lea dx,msg2
		mov ah,09h
		int 21h
		jmp sal
sal1:	lea dx,msg1
		mov ah,09h
		int 21h
sal:	.exit 0
end