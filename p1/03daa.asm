.MODEL SMALL
extrn lee2:near
extrn des2:near
extrn reto:near
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax

		call lee2
		call reto
		mov bl,al
		call lee2
		call reto

		add al,bl
		daa
		mov dl,al
		call des2
		call reto
		.exit 0
end

;Ejemplo de numeros en BCD con suma 