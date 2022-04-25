;Ejemplo de division
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
		mov bx,ax
		call reto 
		call lee2
		mov cl,al 	;Acomodamos lo resultados para poder imprimir 
		mov ax,bx
		call reto
		div cl
		mov bl,ah 	;Resultado de la division
		mov dl,al
		call des2
		call spc
		mov dl,bl	;Residuo de la divicion
		call des2
		.exit 0
end