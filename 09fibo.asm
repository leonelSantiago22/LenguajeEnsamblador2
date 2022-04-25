.MODEL SMALL
extrn desdec:near
extrn leedec:near
extrn reto:near
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		mov es,ax
		call leedec
		push ax 
		call fibo 
		add sp,02
		mov dx,ax
		call desdec
		call reto
		.exit 0 


fibo:	push bp 	;Movemos el base pointer la base de la pila 
		mov bp,sp 	;Creo el nuevo base pointer 
		sub sp,2 	;Creamos una variable local
		mov ax,[bp+4]
		cmp ax,2
		jg f_s1
		mov ax,1
		jmp f_sal
f_s1:	mov ax,[bp+4] 	;volvemos a cargar el dato
		dec ax
		push ax 
		call fibo 
		add sp,2
		mov [bp-2],ax		;f(x-1)
		mov ax,[bp+4]
		sub ax,2 			;Restamos para mandar el siguiente dato a la forma 
		push ax
		call fibo
		add sp,2
		add ax,[bp-2]
		
f_sal:	mov sp,bp 		;movelos lo que tenemos en el base pointer al stack pointer apuntador de controlador de pila
		pop bp		;Salida del base pointer 
		ret

end