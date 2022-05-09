.MODEL SMALL
.STACK
.DATA
.CODE
main: 	mov ax,@data	
		mov ds,ax

		mov ah,01h 		;Leemos la tecla 
		int 21h
		mov bl,al 		;Respaldamos el dato de al en bl para poder ocupar al
		mov ah,01h 		;Leemos el segundo dato
		int 21h 		
		cmp al,bl 		;Comparamos lo que ambos numeros tienes 
		jge sal1		;Hacemos la comparaciones en este caso salta si es mayor o igual
		mov dl,al 		;imprimimos si no se cumple la condicion
		mov ah,02h
		int 21h
		.exit 0 		;salida

sal1:	mov dl,bl 		;Movemos el dato a imprimir si se cumple la condicion
		mov ah,02h 		
		int 21h
		.exit 0

end