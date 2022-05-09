.MODEL SMALL
.STACK
.DATA
cadena db "Hola, mundo", 0Dh, 0Ah, 24h
.CODE
main:	mov ax,@data ;obtener direccion de segmento de datos
		mov ds,ax		; y ponerlo en el registro DS data segment
		mov ah,09h 		;Servicio para desplegar cadena
		mov dx,offset cadena
		int 21h
		.exit 0 ;equivalente a int 21h servicio 4Ch
end						;podria requerir un end main