.MODEL SMALL
.STACK
.DATA
	mensage db "Hola mundo",0Dh, 0Ah, 24h
.CODE
main: 	mov ax,@data		;Mandamos a traer la informacion del mensage
		mov ds,ax			;mandamos a desplegar lo que tenemos en el mensaje
		mov ah,09h			;deplegamos la cade
		mov dx,offset mensage	;mandamos a llamar el offset
		mov cx,05h
ciclo:	int 21h				;paramos el programa
		loop ciclo 			;loop del ciclo
		.exit 0
end 
