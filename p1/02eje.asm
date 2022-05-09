.MODEL SMALL
.STACK
.DATA
	cadena1 db "Hola$"
	cadena2 db "Me llamo Leonel$"
.CODE
main: 	mov ax,@data
		mov ds,ax

		lea dx, cadena1
		mov ah,09h
		int 21h
		lea dx,cadena2
		mov ah,09h
		int 21h
		mov ah,4ch
		int 21
		.exit 0
end