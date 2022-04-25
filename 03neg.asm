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

		;leer 2 positivos y restarlos 
		;Si es negativo desplegarlo correctamente 
		call lee1
		call reto
		mov bl,al
		call lee1
		call reto
		sub bl,al
		mov dl,bl
		call des2
		call reto
		mov cl,bl 
		and bl,80h
		jz despi
		mov ah,02h
		mov dl,'-'
		int 21h
		not cl
		inc cl

despi:	mov dl,cl
		call des2 
		.exit 0

end