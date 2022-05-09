.MODEL SMALL
extrn des4:near
extrn lee2:near
extrn lee1:near
extrn des2:near
extrn des1:near
extrn reto:near
extrn spc:near
.STACK
.DATA
.CODE
main: 	mov ax,@data
		mov ds,ax
		mov bx,0						;acumulador
		mov ch,0

ciclo:	
		call lee1						;Leemos un digito
		cmp al,0DDh	
		je salida
		mov cl,al
		mov ax,0Ah
		mul	bx							;AX x BX, resultado en ax
		add ax,cx						;multiplicar acumulador por A y sumar al dato nuevo
		mov bx,ax
		jmp ciclo

salida:	mov dx,bx
		call des4
		.exit 0

end 
;Ejercicio de base 3, necesitamos sacar los residuos 
