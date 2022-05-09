.MODEL SMALL
.STACK
.DATA
	msg1 db 0Dh,0Ah," Ingresa un numero:[0-9] $"
	msg2 db 0Dh, 0Ah," Ingresa una letra: $", 0Dh, 0Ah, 24h
	;var1 dw ?
.CODE
main:	mov ax,@data
		mov ds,ax

		lea dx,msg1
		mov ah,09h
		int 21h
		mov ah,01h		;movemos el dato a bl un registro seguro esto es el numero 
		int 21h
		mov bl,al 
		sub bl,30h		;Lo convertimos a decimal
		lea dx,msg2
		mov ah,09h
		int 21h
		mov ah,01h		;Leemos la letra 
		int 21h
		mov dl,al
		mov ah,02h
		mov cl,bl
		mov ch,0h
ciclo:	int 21h
		loop ciclo
		.exit 0
end