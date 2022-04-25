;ejemplo de numeros negativos
.MODEL SMALL
extrn lee1:near
extrn des1:near
extrn des2:near
extrn spc:near
extrn reto:near
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax

		mov al,02h		;2
		mov bl,03h		;3
		sub al,bl		;-1
		mov dl,al
		push dx
		call des2
		call reto 
		pop dx
		not dl 
		inc dl
		call des2
		call reto
		.exit 0

end