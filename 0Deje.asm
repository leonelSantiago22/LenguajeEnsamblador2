.MODEL SMALL
.STACK
.DATA
	msg1 db 0Dh,0Ah, "La letra es : $"
.CODE
main:	mov ax,@data
		mov ds,ax
		mov bl,01
ini:	mov ah,01h
		int 21h
		sub al,40h
		add al,60h
		mov dl,al
		mov ah,02h
		int 21h
		inc bl
		cmp bl,06h
		jge sal
		jmp ini
sal:	.exit 0

end
;0D. Hacer cinco veces: leer letra en mayúscula, desplegar en minúscula.