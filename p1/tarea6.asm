.MODEL SMALL
extrn lee4:near
extrn des4:near
extrn lee2:near
extrn spc:near
extrn reto:near
.STACK
.DATA


.CODE
main:	mov ax,@data
		mov ds,ax
		call lee4		;Mandamos a llamar la funcion de leer 4 numeros 
		call reto		;funcion de salto de linea
		mov cx,ax
		call lee2
		call reto
		mov ah,al
		call lee2
		call reto
		add al,ah
		mov ah,0
		add ax,cx
		call des4
		.exit 0
end