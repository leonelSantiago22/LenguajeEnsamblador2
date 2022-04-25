.MODEL SMALL
extrn des2:near
extrn des4:near
extrn reto:near
.stack
.data
.code
suma macro num1, num2		;el macro es una sustitucion no es una funcion si tenemos una etiqueta esta mal 
local ms
	ms: add num1,num2			;ya que se llaman varias veces a la misma etiqueta 
endm 
main:	mov al,4
		mov bl,3
		;suma al bl; los parametros separan con espacio
		suma al bl 		;mandamos a llamar el macro 
		mov dl,al
		call des2
		call reto 
		mov ax,6
		mov cx,2 
		suma ax cx 
		mov dx,ax 
		call des4
		.exit 0
end
