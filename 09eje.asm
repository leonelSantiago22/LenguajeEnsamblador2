.MODEL SMALL
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		int 21h
		mov al,30h
		mov dl,al
		mov ah,02h
		mov cx,06h
ciclo:	int 21h
		inc dl
		loop ciclo
		.exit 0
end
;09. Hacer programa que despliegue 012345 usando LOOP.