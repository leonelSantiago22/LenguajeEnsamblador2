.MODEL SMALL
extrn des4:near
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		mov es,ax			;habilitacion del extra segment

		;Pasamos datos directamente 
		mov ax,05h
		push ax
		mov ax,03h
		push ax
		add sp,04h			;Stack pointer le sumamos 4 
		call fun
		mov dx,ax
		call des4
		.exit 0 
fun:	push bp 
		mov bp,sp

		mov ax,[bp+4]	;Segundo dato, es el 03h
		mov bx,[bp+6]	;Primer dato, es el 05h
		add ax,bx
		;Restauramos el espacio
		mov sp,bp 
		pop bp
		ret

end