.MODEL SMALL
extrn des2:near
.STACK

.DATA

.CODE 

;flecha 

main:	
		mov cx,20h
		;corre y no se espera sin el teclazo
cicilo:	mov ah,00h
        int 16h
		jz sigue    ;si no hubo teclaso brincate a sigue 
		;hubo telazo dato en AL
		mov dl,ah;en al se guarda lo del teclazo y se puede imprimir 
	    call des2
		
		;mov ah,02h
		;int 21h;imprime teclazo
		
sigue:	mov dl,'.'
		mov ah,02h
		int 21h
		call retardo;se llama retardo para poder imprimir 
		loop cicilo
	
		
		.exit 0
		
		
;esc 1b 
;tecla b 64
retardo:
	push cx
	mov cx,0FFFFh
 r_c1:	
 	push cx
 	mov cx,000Fh
 r_c2:	loop r_c2
 
 	pop cx
 
 
 	loop r_c1
 	pop cx
 	ret
end


