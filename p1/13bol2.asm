.MODEL SMALL
extrn spc:near
extrn reto:near
.STACK
.DATA
	var1 db ?
.CODE
main:	mov ax,@data
		mov ds,ax
		mov ah,01h
		int 21h
		mov bh,al
		sub bh,30h
		mov var1,bh		
		call reto
		mov bl,01h	
cicl1:	mov cl,bl
		mov ch,0
		mov dl,'o'
cicl2: 	mov ah,02h
		int 21h
		loop cicl2
		call reto
		inc bl
		cmp bl,var1
		jle cicl1
		.exit 0
end