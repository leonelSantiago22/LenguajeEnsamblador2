;Ejemplo de multiplicacion
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
		call lee2
		call reto
		mov bl,al
		call lee2 		;datos en bl y al
		call reto
		mul bl			;Al * BL resultado en AX entonces asi multiplico bl por al
		mov dx,ax
		call des4		;Resultado en AX
		.exit 0
end