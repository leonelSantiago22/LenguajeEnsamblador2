.MODEL SMALL 
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		
		call lee4		;Mandamos a llamar la funcion de leer 4 numeros 
		call reto		;funcion de salto de linea
		mov bx,ax		;respaldamos lo que tenmos en el registro de 16 bits ax en bx
		call lee4		;leemos la siguiente parte del codigo
		add ax,bx		;Ya tenemos en ax algo y ahora lo sumamos con lo antes respaldad
		mov dx,ax		;Movemos a dx para poder imprimir el registro de ax
		call reto		;Salto de linea
		call des4		;Desplegamos la suma de ambos numeros
		.exit 0

reto:	push ax
		push dx			;Retorno
		mov ah,02h
		mov dl,0Dh 		;codigo para el salto de linea
		int 21h
		mov dl,0Ah
		int 21h
		pop dx
		pop ax
		ret
spc:	push ax 
		push dx 
		mov ah,02h
		mov dl, 20h ;Hexadecimal del espacio 
		int 21h
		pop dx
		pop ax 
		ret
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
lee2:	push bx			;blidamos la funcion para que no sea un problema utilizar Bl 
		call lee1		;dato en al
		shl al,04		;Desplazar isquierda
		mov bl,al 		;poner en el Bl
		call lee1
		add al,bl		;acomodar y juntarlos lo de Al y Bl 		;devolver en al
		pop bx
		ret
des2:	push dx				;dato en dl, pe: 3B
		shr dl,4h			;Recuperar de Bl
		call des1
		pop dx
		and dl,0fh					;Filtar la parte derecha; pe: 0B
		call des1
		ret
lee4:	push bx
		call lee2			;12h
		mov bl,al			;resplandamos lo que tenermos en al en el registro bl
		call lee2			;Mandar a llamar para leer 2 numeros 
		mov ah,bl			;completamos el registro ax moviendo a su parte alta lo que tenemos en bl
		pop bx
		ret
des4:	push bx
		mov bl,dl		;Remplazamos lo que tenemos en dl a bl
		mov dl,dh 	;el dato esta en dl 
		call des2   ;desplegamos pa primera parte que tenemos en la parte alta de dx
		mov dl,bl		;Desplegamos la siguiente parte que es la parte baja de dx
		call des2		;Desplegamos 
		pop bx			;Regresamos el valor de bx a su original
		ret
end
