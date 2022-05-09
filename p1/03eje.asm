.MODEL SMALL
.STACK
.DATA
	messagge1 db "La tecla introducida es : $"
.CODE
main:	mov ax,@data
		mov ds,ax

		mov ah,01h
		int 21h
		lea dx,messagge1
		mov ah,09h
		int 21h
		mov dl,al
		mov ah,02h
		int 21h
		.exit 0
end
;Ejercicio 3 de los problemas de zarza