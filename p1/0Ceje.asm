.MODEL SMALL
.STACK
.DATA
.CODE
main: 	mov ax,@data
		mov ds,ax
		
		int 21h
		mov al,41h 
		mov ah,02h
		mov dl,al
		mov cx,10h
ciclo:	int 21h
		add al,20h
		add al,01h
		mov dl,al
		mov ah,02h
		int 21h
		add al,01h
		sub dl,20h
		loop ciclo
		.exit 0
end