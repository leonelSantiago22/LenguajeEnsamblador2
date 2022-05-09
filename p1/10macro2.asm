.MODEL SMALL
extrn des2:near
extrn des4:near
extrn reto:near
.STACK
.DATA
.CODE
lapusha macro 
	push ax 
	push bx 
	push cx 
	push dx 
	push si 
	push di 
endm
lapopa macro 
	pop di 
	pop si 
	pop dx 
	pop cx 
	pop bx 
	pop ax 
endm
repeletra macro letra,repe 
local rlsalto		;decimos que la etiqueta es local, para que no nos marque el error 
		lapusha 
		mov ah,02
		mov dl,letra
		mov cx,repe
rlsalto:int 21h
		loop rlsalto
		lapopa
endm
main:  	repeletra 41h 10h  ;letra y numero de veces 
		call reto
		repeletra 'B' 0Ah 
		.exit 0
end