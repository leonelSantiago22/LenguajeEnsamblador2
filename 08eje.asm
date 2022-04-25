.MODEL SMALL
.STACK
.DATA 
	nombre db "Leonel $"
.CODE
main:	mov ax,@data
		mov ds,ax
		lea dx,nombre
		mov ah,09h
		mov cx,06h
ciclo:	int 21h
		inc dx
		loop ciclo
		.exit 0
	
end
;Programa 8 de los ejercicio de zarza
;08. Desplegar el nombre así:Jordan ordan rdan dan an n.