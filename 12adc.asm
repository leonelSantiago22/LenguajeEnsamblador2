.MODEL SMALL
extrn lee4:near
extrn des4:near
extrn des2:near
extrn lee2:near
extrn spc:near
extrn reto:near
.STACK
.DATA
;arreglo db 01h,02h,03h,04h ;Arreglo de numeros que queremos imprimir 
.CODE
main:	mov ax,@data
		mov ds,ax
		call lee2
		;call reto
		mov ch,al
		call lee2
		call reto
		mov cl,al
		;Lectura del segundo numero
		call lee2 
		mov bh,al
		;call reto
		call lee2
		mov bl,al
		call reto

		add cl,bl 			;primero sumar del lado derecho, resultado bajo bl y carry
		adc ch,bh 			;resu alto en bh  y Carry 
		push cx
		jnc aqui			;Salta si no hay acarreo
		mov dl,'1'
		mov ah,02h
		int 21h
aqui:	pop cx
		mov dx,cx
		call des4
		.exit 0

end
;suma con acarreo o resta con acarreo