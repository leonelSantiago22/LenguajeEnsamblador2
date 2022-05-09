.MODEL SMALL
extrn spc:near
extrn reto:near
.STACK
.DATA
	var1 db ?
	msg1 db "o$"
.CODE
main:	mov ax,@data
		mov ds,ax
		mov ah,01h
		int 21h
		mov bh,al
		sub bh,30h
		shl bh,01h
		sub bh,01h 
		mov bl,01h
		mov var1,bh
		sub var1,01h
cic1: 	mov cl,bl
		mov ch,0
		lea dx,msg1
		push cx
		mov cl,var1
		mov ch,0
		mov dl,'.'
		mov ah,09h
espc:	int 21h
		loop espc
		pop cx
		dec var1
cic2:	mov ah,09h
		int 21h
		loop cic2
		add bl,02
		cmp bl,bh
		call reto
		mov ah,02h
		int 21h
		jle cic1
		.exit 0
end