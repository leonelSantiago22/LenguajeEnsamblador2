.MODEL SMALL
.STACK
.DATA
;cadena db "Hola, mundo", 0Dh, 0Ah, 24h
.CODE
main:	mov ax,@data ;obtener direccion de segmento
		mov ds,ax 
		mov ah,02h
		mov dl,41h ;necesitamos agregar el h 
		mov cx,05h
ciclo: 	int 21h
		loop ciclo ;ponemos el nombre de la etiqueta
		.exit 0
end 