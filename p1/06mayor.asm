;Ejercicio programa que tenga n funcion, la funcion va a leer datos del usuario
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
		call max 		;funcion que encuentre el numero mayor 
		mov dx,ax
		call desdec

		.exit 0
		;Calcula el maximo de 5 numeros leidos 


max:	push bp 	;Movemos el base pointer la base de la pila 
		mov bp,sp 	;Creo el nuevo base pointer 
		sub sp,02h	;Creamos la variable localizada car local : [bp+2]

		call leedec ;mandamos a llamar para leer el numero
		call reto 
		mov [bp-2],ax 	;Mandamos lo que llamamos en ax 
		mov cl,04h
		mov ch,0h
fsic:	call leedec
		call reto 
		cmp ax,[bp-2]		;Compara lo que ingresamos con lo que ya tenemos en la pila 
		jl salto 			;jump is low, salta si es menor
		mov [bp-2],ax 		;movemos si viene un numero mas grande a la variable local 
salto:	loop fsic
		mov ax,[bp-2]	
		mov sp,bp 		;movelos lo que tenemos en el base pointer al stack pointer apuntador de controlador de pila
		pop bp		;Salida del base pointer 
		ret
end
