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
		add bx,03h 			;Esto lo hago para arrancar en la posicion final
		;mov ah,02h
ciclo:	mov dl,[bx]			;Cargamos la direcion de donde empieza el arreglo 
		call des2			;Es necesario mandar a llamar lo que tenemos para desplegar con dees2
		;int 21h			;Por eso no se utiliza int 21h ya que no se encuentra en hexadecimal
		call spc
		dec bx				;Decremento para sacar el arreglo al revez
		loop ciclo 			;Segun nos va a desplegar lo que tenemos en el arreglo		
		.exit 0
end