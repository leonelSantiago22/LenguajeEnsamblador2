;Ejemplo de multiplicacion de multiplicacion de 16 bits salida de 32 bits
.MODEL SMALL
extrn spc:near
extrn reto:near
extrn lee4:near
extrn des4:near
extrn lee2:near
extrn des2:near
.STACK
.DATA
.CODE
main: 	mov ax,@data
		mov ds,ax
		call lee4
		call reto
		mov bx,ax
		call lee4 		;datos en bl y al
		call reto
		mul bx			;Ax * Bx resultado en DX-AX entonces asi multiplico bl por a
		mov bx,ax 		;Resoladamos la parte baja del resultado
		mov dx,dx       ;imprimo la parte alta del resultado
		call des4		;Resultado en AX
		mov dx,bx		;Mando a imprimir la parte baja del resultado
		call des4
		.exit 0
end