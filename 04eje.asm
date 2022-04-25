.MODEL SMALL
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		mov ah,01h
		int 21h
		sub al,40h
		add al,60h
		mov dl,al
		mov ah,02h
		int 21h
		.exit 0
end
;Leer una letra en mayuscula y desplegarla en minuscula 