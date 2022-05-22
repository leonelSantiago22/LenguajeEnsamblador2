.model small
extrn des2:near
.stack
.data
.code
main:   mov ax,@data
        mov ds,ax 

        mov cx,0FFh
ciclo:  mov ah,06h       ;
        mov dl,0FFh        ;Si pongo 0ffh es para leer peroo si acsii es para escribir
        int 21h
        jz sigue                ;si no hubo teclazo brincate a sigue
        ;hubo teclaso dato en al
        cmp al,20h
        je salir
        mov dl,al
        call des2
sigue:  mov dl,'.'
        mov ah,02h
        int 21h
        call retardo
        loop ciclo
salir:        .exit 0
retardo:
	push cx
	mov cx,0100h
 r_c1:	
 	push cx
 	mov cx,0200h
 r_c2:	loop r_c2
 
 	pop cx
 
 
 	loop r_c1
 	pop cx
 	ret
end