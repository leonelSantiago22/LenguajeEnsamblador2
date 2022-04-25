.MODEL SMALL
extrn des4:near
extrn lee2:near
extrn lee1:near
extrn des2:near

.STACK
.DATA
.CODE
main: 	mov ax,@data
		mov ds,ax
		call des4
		mov ah,0
		mov bl,03
		div bl
		mov dl,ah
		call des2
		mov ah,0
		div bl
		mov dl,ah
		call des2
		.exit 0
end
;Ejercicio de base 3, necesitamos sacar los residuos 