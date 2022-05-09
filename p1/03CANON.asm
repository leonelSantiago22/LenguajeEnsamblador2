.MODEL SMALL
.STACK
.DATA
.CODE
main:	mov ah,01
		int 21h
		push dx 
		mov ah,01h
		int 21h
		mov cx,al
		pop dx 
		mov dl,al
		mov ah,02h
ciclo:	int 21h
		loop ciclo
		.exit 0
end 