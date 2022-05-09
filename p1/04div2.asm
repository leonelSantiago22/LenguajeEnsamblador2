;Ejemplo de division de 32 bits
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
		mov dx,ax
		call lee4
		mov bx,ax
		call reto
		call lee4
		mov cx,ax
		mov ax,bx
		call reto
		div cx			;Datos de DX-AX 
		mov bx,dx
		mov dx,ax
		call des4
		call spc
		mov dx,bx	;Residuo de la divicion
		call des4
		.exit 0
end