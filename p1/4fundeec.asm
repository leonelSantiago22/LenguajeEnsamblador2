.MODEL SMALL
extrn des4:near
extrn lee4:near
extrn lee1:near
extrn des2:near
extrn des1:near
extrn reto:near
extrn spc:near
extrn leedec:near
extrn desdec:near
.STACK
.DATA
.CODE
main: 	mov ax,@data
		mov ds,ax
		call leedec
		call reto
		mov dx,ax
		call desdec
		.exit 0
end 
;Ejercicio de base 3, necesitamos sacar los residuos