.MODEL SMALL
.STACK
.DATA 
	nombre db "Leonel", 0Dh, 0Ah, 24h
.CODE 
main:	mov ax,@data 
		mov ds,ax
		mov ah,09h
		lea dx,nombre
		mov cx,03h
ciclo:	int 21h
		loop ciclo
		.exit 0

	
end
;Desplegar el nombre 3 veces tu nombre 