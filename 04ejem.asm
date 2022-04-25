.MODEL SMALL
.STACK
.DATA
	nombre db "Leonel $"
.CODE
main:	mov ax,@data
		mov ds,ax
		mov ah,09h
		lea dx,nombre   ;lea dx,nombre low efective address nos ayuda a desplegar mas facil remplazando mov dx,offset nombre
		mov cx,6h
ciclo:	int 21h
		inc dx
		loop ciclo 
		.exit 0 
end