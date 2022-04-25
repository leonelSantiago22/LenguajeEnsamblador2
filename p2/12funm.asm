.MODEL SMALL 
extrn desdec:near
extrn leedec:near
extrn reto:near
.STACK
.DATA
.CODE
llamaf macro uno,dos
	mov ax,uno 
	mov bx,dos
	push ax 		;[bp+6]
	push bx 		;[bp+4]
	call fun 
	add sp,4
endm
main:	mov ax,@data
		mov ds,ax

		call leedec
		mov bx,ax
		call leedec
		llamaf ax bx
		mov dx,ax 
		call desdec
		.exit 0  
;Recibe 2 parametros y devuelve el mayor 
fun:	push bp
		mov bp,sp 
		mov ax,[bp+6]
		mov bx,[bp+4]	
		cmp ax,bx
		jg fsal
		mov ax,bx
fsal:	mov sp,bp
		pop bp 
		ret
end