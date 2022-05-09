.MODEL SMALL
extrn lee4:near
extrn des4:near
extrn des2:near
extrn lee2:near
extrn spc:near
extrn reto:near
.STACK
.DATA
arreglo db 01h,02h,03h,04h
.CODE
main: 	mov ax,@data
		mov ds,ax
		mov cx,04h
		lea bx,arreglo		;ya tenemos una direccion y apuntamos al inicio
		mov si,0 				;primer elemento del arreglo
ciclo:	mov dl,[bx+si]			;Cargamos la direcion de donde empieza el arreglo 
		call des2			;Es necesario mandar a llamar lo que tenemos para desplegar con dees2
		;int 21h			;Por eso no se utiliza int 21h ya que no se encuentra en hexadecimal
		call spc
		inc si				;Decremento para sacar el arreglo al revez
		loop ciclo 			;Segun nos va a desplegar lo que tenemos en el arreglo		
		.exit 0
end