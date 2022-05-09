.MODEL SMALL
.STACK
.DATA
		cadena db "Hola mundo$"
.CODE
main:	mov ax,@data
		mov ds,ax

		lea dx,cadena 
		mov ah,09h
		int 21h
		.exit 0

end