.MODEL SMALL 
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		call lee1	;Dato en al
		inc al
		mov dl,al   ;Como voy a llamar una funcion de despliegue se lo necesito dejar en dl
		call des1   

		.exit 0

lee1:	mov ah,01h ;Leemos lo que tenemos en el teclaso
		int 21h		
		sub al,30h	;Restamos lo que tenemos en al 30
		cmp al,09h	;Comparamos que sea mayor que 9
		jle l1s	;Si no ee mayor que 09 h saltamos a la salida
		sub al,07h	;Si no cumplen las condiciones le restamos otros 07
		cmp al,0Fh	;comparamos si es mayor que 0fh
		jle l1s 	;Si no saltamos a la saldia
		sub al,20h	;Si no se cumplen las condiciones anteriores le restamos 20
l1s:	ret
;Despliegue de un diguito, dato en dl
des1:	add dl,30h
		cmp dl,39h
		jle salida
		add dl,07h
salida:	mov ah,02h 
		int 21h
		
		ret
end