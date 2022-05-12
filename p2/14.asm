;Programa que calcula factorial de un número decimal, cuyo resultado máximo sea de 4 dígitos decimales. Las operaciones deberán realizarse en hexadecimal.
.model small
extrn leedec:near
extrn desdec:near
extrn reto:near
.stack
.data
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax
        
        call leedec
        push ax         ;mandamos a la pila lo que tenemos a leer
        call sumrec
        add sp,02       ;Restauramos la pila 
        mov dx,dx 
        call desdec     ;Desplegamos el resultado
        mov dx,ax
        call desdec
        call reto
        .exit 0

;suma recursiva para el factorial las operaciones estan dadas por hexadecimal
sumrec:	push bp 	;Movemos el base pointer la base de la pila 
		mov bp,sp 	;Creo el nuevo base pointer 
		mov ax,[bp+4]		;buscamos el dato en la pila ;parametro (el ultimo y el unico)
		cmp ax,1
		jg	sr_1			;suma recursiva punto de salto 1
		mov ax,1
		jmp sr_s			;suma recursiva punto de salto en salida
sr_1:	mov ax,[bp+4]
		dec ax
		push ax				;Asi es como pasamos el parametro a la funcion es otra invocacion separada 
		call sumrec 		;Resultado en ax
		add sp,02h			;Restauramos la pila
		mov dx,[bp+4]		
		mul dx				;Sumamos el resultado mas el parametro de la funcion guardandolo en DX-AX
		;Ignoramos la parte alta
sr_s:	;Dejando en AX el resultado
		mov sp,bp 		;movelos lo que tenemos en el base pointer al stack pointer apuntador de controlador de pila
		pop bp		;Salida del base pointer 
		ret
end