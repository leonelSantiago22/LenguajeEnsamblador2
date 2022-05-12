;problema que haga elever un numero cierta cantidad de veces 
.model small
extrn desdec:near
extrn leedec:near
extrn reto:near
.stack
.data
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax 
        call leedec
        push ax  
        call leedec
        push ax 
        call expo
        add sp,04h
        call desdec
        mov dx,ax 
        call desdec
        .exit 0

expo:   push sp
        mov bp,sp
        mov cx,[bp+6]
        mov dx,[bp+6]
        mov ax,[bp+4]
ini:    cmp cx,0
        je salida
        dec cx
        mul dx
        jmp ini
salida: mov dx,ax
        mov ax,ax
        mov sp,bp 		;movelos lo que tenemos en el base pointer al stack pointer apuntador de controlador de pila
		pop bp
        ret
end