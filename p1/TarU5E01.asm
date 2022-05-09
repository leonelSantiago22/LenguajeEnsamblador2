.MODEL SMALL
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		mov ah,01h			;ingresamos el primer dato
		int 21h				
		mov bl,al			;movemos el dato a un posicion donde no se pueda modificar			;regresamos a al a un valor de 0 
		mov ah,01h 			;Leemos el siguiente digito
		int 21h 			
		add al,bl 			;Sumamos ambos numeros
		sub al,30h			;Le restamos 30 posiciones
		mov dl,al
		mov ah,02h
		int 21h
		.exit 0
end