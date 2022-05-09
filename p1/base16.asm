.MODEL SMALL
extrn des4:near
extrn lee2:near
extrn lee1:near
extrn des2:near
extrn des1:near
extrn reto:near
extrn spc:near
.STACK
.DATA
.CODE
main: 	mov ax,@data
		mov ds,ax
		call lee1
		call reto
		mov dl,al
		call des1
		.exit 0 

end
;Ejercicio de base 3, necesitamos sacar los residuos 