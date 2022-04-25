.MODEL SMALL
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		mov ah,01h
		int 21h
		mov dl,al		;La letra a un esta en dl
		int 21h
		sub al,30h		;Le restamos 30 para que deje de ser codigo asccii
		mov cl,al 
		mov ch,0 		;Esto es un relleno
		mov ah,02h
ciclo: 	int 21h
		loop ciclo
		.exit 0
end 