.MODEL SMALL
extrn spc:near
extrn reto:near
.STACK
.DATA
	var1 db ?
	var2 db ?
	var3 db ?
.CODE
main:	mov ax,@data
		mov ds,ax
		mov ah,01h
		int 21h
		mov bh,al
		sub bh,30h
		mov var1,bh
		mov var2,bh
		mov var3,bh
		call reto
		mov bl,01h
ini:	dec var3
		mov cl,var2
		mov ch,0
		mov dl,' '
cic1:	mov ah,02h
		int 21h
		loop cic1
		dec var2
cicl1:	mov cl,bl
		mov ch,0
		mov dl,'o'
cicl2: 	mov ah,02h
		int 21h
		loop cicl2
		add bl,02
		call reto
		cmp var3,0
		jg ini
		.exit 0
end