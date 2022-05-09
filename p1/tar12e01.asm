.MODEL SMALL
extrn desdec:near
extrn leedec:near
extrn reto:near
.STACK
.DATA
	contenedor dw ?
.CODE
main:	mov ax,@data
		mov ds,ax
		mov es,ax
		call leedec 
		push ax 		;[bp+8]
		call leedec 
		push ax 		;[bp+6]
		mov ax, offset contenedor 
		push ax			;[bp+4]
		call fun3 		;mandamos a llamar la funcion
		add sp,06		;restauramos la pila
		mov dx,contenedor	;extraemos lo que tenemos en el contenedor
		call desdec			;imprimimos el resultado
		.exit 0

fun3:	push bp 			;Movemos el base pointer la base de la pila 
		mov bp,sp 			;Creo el nuevo base pointer 
		mov bx,[bp+8]		;pasamos lo que tenemos en la pila 
		mov cx,[bp+6]		;pasamos lo que tenemos en la pila 
		cmp  bx,cx			;cmp lo que tenemos en bx lo de cx 
		jle cas				;mandamos a llamar en caso de que cx sea mayor de bx 
		sub bx,cx			;restamos lo que tenemos bx y cx
		mov ax,bx			;movemos el resultado a ax 
		jmp sali 			;saltamos a la salida
cas:	sub cx,bx 			;segundo caso donde cx sea mas grande que bx
		mov ax,cx 			;el resultado de la resta a bcc
sali:	mov bx,[bp+4]		;mandamos a traer el espacio donde se reservo la variable 
		mov [bx],ax			;mandamos al espacio de la pila de la variable lo que tenemos en ax
		mov sp,bp 		;movelos lo que tenemos en el base pointer al stack pointer apuntador de controlador de pila
		pop bp		;Salida del base pointer 
		ret
end