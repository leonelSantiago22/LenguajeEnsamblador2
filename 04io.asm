.MODEL SMALL 
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax

		mov ah,01h ;Leemos lo que tenemos en el teclaso
		int 21h		
		sub al,30h	;Restamos lo que tenemos en al 30
		cmp al,09h	;Comparamos que sea mayor que 9
		jle salto	;Si no ee mayor que 09 h saltamos a la salida
		sub al,07h	;Si no cumplen las condiciones le restamos otros 07
		cmp al,0Fh	;comparamos si es mayor que 0fh
		jle salto 	;Si no saltamos a la saldia
		sub al,20h	;Si no se cumplen las condiciones anteriores le restamos 20
salto:	dec al 		;Incrementamos el al  en 1 o dec para decrementar
		mov dl,al
		add dl,30h
		cmp dl,39h
		jle salida
		add dl,07h
salida:	mov ah,02h 
		int 21h
		.exit 0
		
end